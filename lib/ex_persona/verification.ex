defmodule ExPersona.Verification do
  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  def get(id), do: %Operation{path: "verifications/#{id}", parser: &Verification.parse/1}

  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Verification{data: data, id: data["id"]}}
end
