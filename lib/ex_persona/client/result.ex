defmodule ExPersona.Client.Result do
  alias ExPersona.Client.Streamable
  alias __MODULE__

  defstruct [:body, :parsed, :operation]

  def from_encoded(body, headers, operation) when is_binary(body) do
    headers
    |> Enum.into(%{})
    |> Map.get("Content-Type")
    |> case do
      "application/json" <> _ ->
        %Result{body: body, parsed: Jason.decode!(body), operation: operation}

      _ ->
        %Result{body: body, operation: operation}
    end
  end

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
