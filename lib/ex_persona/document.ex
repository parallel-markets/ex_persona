defmodule ExPersona.Document do
  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  def get(id), do: %Operation{path: "documents/#{id}", parser: &Document.parse/1}

  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Document{data: data, id: data["id"]}}

  def has_file?(%Document{data: data}, name) do
    !is_nil(get_in(data, ["attributes", name, "url"]))
  end

  def download_file(%Document{data: data}, name) do
    case get_in(data, ["attributes", name, "url"]) do
      nil ->
        {:error, :no_file}

      url ->
        %Operation{path: url}
    end
  end
end
