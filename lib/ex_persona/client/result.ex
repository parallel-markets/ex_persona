defmodule ExPersona.Client.Result do
  @moduledoc """
  This module is used to represent the result of an API call.

  It is passed to the parser specified in a given `ExPersona.Client.Operation` and the
  result is what's returned from an `ExPersona.Client.request/1`.
  """
  alias ExPersona.Client.{Operation, Streamable}
  alias __MODULE__

  defstruct [:body, :parsed, :operation, :headers]

  @type t :: %__MODULE__{
          body: binary(),
          parsed: map() | nil,
          operation: Operation.t(),
          headers: list()
        }

  @doc """
  Convert the raw results of an API call and turn them into a `ExPersona.Client.Result`.
  """
  @spec from_encoded(String.t(), list(), Operation.t()) :: Result.t()
  def from_encoded(body, headers, operation) when is_binary(body) do
    headers
    |> Enum.map(fn {k, v} -> {String.downcase(k), v} end)
    |> Enum.into(%{})
    |> Map.get("content-type")
    |> case do
      "application/json" <> _ ->
        %Result{body: body, parsed: Jason.decode!(body), operation: operation, headers: headers}

      _ ->
        %Result{body: body, operation: operation, headers: headers}
    end
  end

  @doc """
  Convert the `ExPersona.Client.Result` of an API call and turn it into a `ExPersona.Client.Streamable`.

  This is used in cases where we expect the result to contain pagination.
  """
  @spec to_streamable(Result.t()) :: Streamable.t()
  def to_streamable(%Result{parsed: %{"links" => links}, operation: op}) do
    cursor = extract_cursor(links)
    %Streamable{operation: op, cursor: cursor, closed: is_nil(cursor)}
  end

  defp extract_cursor(%{"next" => nil}), do: nil

  defp extract_cursor(%{"next" => ""}), do: nil

  defp extract_cursor(%{"next" => url}) do
    url
    |> URI.parse()
    |> Map.get(:query)
    |> Kernel.||("")
    |> URI.decode_query()
    |> Map.get("page[after]")
  end
end
