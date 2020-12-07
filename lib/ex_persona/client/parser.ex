defmodule ExPersona.Client.Parser do
  @moduledoc """
  This module contains functions used in parsing the results of API calls.

  In this context, "parsing" occurs after JSON responses have been decoded into a `Map`.
  """
  alias ExPersona.Client.Result

  @typedoc """
  A single result from a parsed API call.
  """
  @type parsed_single_result :: {:ok, struct()} | {:error, String.t()}

  @typedoc """
  A result from a parsed API call that is streamable (i.e., a pagninated list).
  """
  @type parsed_list_result :: {:ok, struct(), Streamable.t()} | {:error, String.t()}

  @typedoc """
  Either a single or list result.
  """
  @type parsed_result :: parsed_result | parsed_list_result

  @type parser_func :: (Result.t() -> parsed_result)

  @doc """
  Provide a default parser in case an `ExPersona.Client.Operation` doesn't specify one.

  This just returns the body of the response.  This is useful for downloading files, for
  instance, where there's no transformation that should be done on the result.
  """
  @spec default_parse(Result.t()) :: parsed_result()
  def default_parse(%Result{body: body}), do: {:ok, body}

  @doc """
  Turn a parser designed for a single record into one that can handle lists.

  This is used in cases where the expected result of an `ExPersona.Client.Operation` is one
  that can handle pagination, and we'd like to just specify a single parser.  For instance,
  the `ExPersona.Inquiry.list/0` function just creates this struct:

       %Operation{path: "inquiries", parser: Parser.list_parser(&Inquiry.parse/1)}

  where `Inquiry.parse/1` describes how to handle creating one `ExPersona.Inquiry` from a
  `ExPersona.Client.Result`.
  """
  @spec list_parser(parser_func()) :: (Result.t() -> parsed_list_result())
  def list_parser(func) do
    fn %Result{parsed: %{"data" => data}} = result ->
      data
      |> Enum.reduce_while([], fn datum, acc -> reduce_result(datum, acc, result, func) end)
      |> case do
        {:error, msg} ->
          {:error, msg}

        list ->
          {:ok, list, Result.to_streamable(result)}
      end
    end
  end

  defp reduce_result(datum, acc, result, parser) do
    %Result{result | parsed: %{"data" => datum}}
    |> parser.()
    |> case do
      {:ok, resp} ->
        {:cont, acc ++ [resp]}

      {:error, msg} ->
        {:halt, {:error, msg}}
    end
  end
end
