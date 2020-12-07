defmodule ExPersona.Inquiry do
  @moduledoc """
  Module for dealing with [inquiries](https://docs.withpersona.com/reference#inquiries).
  """

  alias ExPersona.Client.{Operation, Parser, Result}
  alias __MODULE__

  defstruct [:data, :included, :id]

  @type t :: %__MODULE__{data: map(), included: map() | nil, id: String.t()}

  @doc """
  Get a list of `ExPersona.Inquiry`s.

  If passed to `ExPersona.request!/1` it will return only the first results from the list.
  You can create a `Stream` to paginate over all results by calling `ExPersona.stream!/1`.

  For instance:

       # get 400 inquiries
       ExPersona.Inquiry.list()
       |> ExPersona.stream!()
       |> Stream.take(400)
       |> Enum.to_list()
       |> IO.inspect()
  """
  @spec list() :: Operation.t()
  def list, do: %Operation{path: "inquiries", parser: Parser.list_parser(&Inquiry.parse/1)}

  @doc """
  Get a specific `ExPersona.Inquiry`.
  """
  @spec get(String.t()) :: Operation.t()
  def get(id), do: %Operation{path: "inquiries/#{id}", parser: &Inquiry.parse/1}

  @doc false
  def parse(%Result{parsed: %{"data" => data} = input}),
    do: {:ok, %Inquiry{data: data, included: Map.get(input, "included", %{}), id: data["id"]}}

  @doc """
  Get a list of all document ids referenced in this `ExPersona.Inquiry`.
  """
  @spec get_document_ids(Inquiry.t()) :: [String.t()]
  def get_document_ids(%Inquiry{data: data}) do
    case get_in(data, ["relationships", "documents", "data"]) do
      nil ->
        []

      docs ->
        Enum.map(docs, &Map.get(&1, "id"))
    end
  end
end
