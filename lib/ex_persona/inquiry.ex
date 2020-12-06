defmodule ExPersona.Inquiry do
  alias ExPersona.Client.{Operation, Parser, Result}
  alias __MODULE__

  defstruct [:data, :included, :id]

  def list, do: %Operation{path: "inquiries", parser: Parser.list_parser(&Inquiry.parse/1)}

  def get(id), do: %Operation{path: "inquiries/#{id}", parser: &Inquiry.parse/1}

  def parse(%Result{parsed: %{"data" => data} = input}),
    do: {:ok, %Inquiry{data: data, included: Map.get(input, "included", %{}), id: data["id"]}}

  def get_document_ids(%Inquiry{data: data}) do
    case get_in(data, ["relationships", "documents", "data"]) do
      nil ->
        []

      docs ->
        Enum.map(docs, &Map.get(&1, "id"))
    end
  end
end
