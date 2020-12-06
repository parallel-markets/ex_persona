defmodule ExPersona.Client.Parser do
  alias ExPersona.Client.Result

  def default_parse(%Result{body: body}), do: {:ok, body}

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
