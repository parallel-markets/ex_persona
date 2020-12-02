defmodule ExPersona.Inquiry do
  alias ExPersona.{Operation, Parsers}
  alias __MODULE__

  defstruct [:data, :included, :id]

  def get(id), do: %Operation{path: "inquiries/#{id}", parser: &Inquiry.parse/1}

  def parse(result) do
    case Parsers.json(result) do
      {:ok, %{"data" => data, "included" => included}} ->
        {:ok, %Inquiry{data: data, included: included, id: data["id"]}}

      error ->
        error
    end
  end

  def get_document_ids(%Inquiry{data: data}) do
    case get_in(data, ["relationships", "documents", "data"]) do
      nil ->
        []

      docs ->
        Enum.map(docs, &Map.get(&1, "id"))
    end
  end
end
