defmodule ExPersona.Account do
  alias ExPersona.Client.{Operation, Parser, Result}
  alias __MODULE__

  defstruct [:data, :id]

  def list, do: %Operation{path: "accounts", parser: Parser.list_parser(&Account.parse/1)}

  def get(id), do: %Operation{path: "accounts/#{id}", parser: &Account.parse/1}

  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Account{data: data, id: data["id"]}}
end
