defmodule ExPersona.Verification do
  @moduledoc """
  Module for getting a specific [verification](https://docs.withpersona.com/reference#verifications).
  """

  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  @type t :: %__MODULE__{data: map(), id: String.t()}

  @doc """
  Get a specific `ExPersona.Verification`.
  """
  @spec get(String.t()) :: Operation.t()
  def get(id), do: %Operation{path: "verifications/#{id}", parser: &Verification.parse/1}

  @doc false
  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Verification{data: data, id: data["id"]}}
end
