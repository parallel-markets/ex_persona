defmodule ExPersona.Document do
  @moduledoc """
  Module for getting a [document](https://docs.withpersona.com/reference#retrieve-a-document)'s
  metadata and downloading its contents.

  For instance:

      doc = ExPersona.Document.get("an-id") |> ExPersona.request!()
      if Document.has_file?(doc, "front_image") do
        {:ok, body} = Document.download_file(doc, "front_image")
        File.write("front_image.png", body)
      end  
  """

  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  @type t :: %__MODULE__{data: map(), id: String.t()}

  @doc """
  Get a specific `ExPersona.Document`.
  """
  @spec get(String.t()) :: Operation.t()
  def get(id), do: %Operation{path: "documents/#{id}", parser: &Document.parse/1}

  @doc false
  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Document{data: data, id: data["id"]}}

  @doc """
  Determind if the `ExPersona.Document` contains a file with the given name.
  """
  @spec has_file?(Document.t(), String.t()) :: boolean()
  def has_file?(%Document{data: data}, name) do
    !is_nil(get_in(data, ["attributes", name, "url"]))
  end

  @doc """
  Create an `ExPersona.Client.Operation` to then request for a file's contents.
  """
  @spec download_file(Document.t(), String.t()) :: Operation.t()
  def download_file(%Document{data: data}, name) do
    case get_in(data, ["attributes", name, "url"]) do
      nil ->
        {:error, :no_file}

      url ->
        %Operation{path: url}
    end
  end
end
