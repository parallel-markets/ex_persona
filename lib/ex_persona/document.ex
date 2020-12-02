defmodule ExPersona.Document do
  alias ExPersona.{Client, Operation, Parsers}
  alias __MODULE__

  defstruct [:data, :id]

  def get(id), do: %Operation{path: "documents/#{id}", parser: &Document.parse/1}

  def parse(result) do
    case Parsers.json(result) do
      {:ok, %{"data" => data}} ->
        {:ok, %Document{data: data, id: data["id"]}}

      error ->
        error
    end
  end

  def has_file?(%Document{data: data}, name) do
    !is_nil(get_in(data, ["attributes", name, "url"]))
  end

  def download_file(%Document{data: data}, name) do
    case get_in(data, ["attributes", name, "url"]) do
      nil ->
        nil

      url ->
        Client.get(url)
    end
  end
end
