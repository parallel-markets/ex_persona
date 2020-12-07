defmodule ExPersona.Account do
  @moduledoc """
  Module for dealing with [accounts](https://docs.withpersona.com/reference#accounts-1).
  """

  alias ExPersona.Client.{Operation, Parser, Result}
  alias __MODULE__

  defstruct [:data, :id]

  @type t :: %__MODULE__{data: map(), id: String.t()}

  @doc """
  Get a list of all accounts.

  If passed to `ExPersona.request!/1` it will return only the first results from the list.
  You can create a `Stream` to paginate over all results by calling `ExPersona.stream!/1`.

  For instance:

       # get 400 accounts
       ExPersona.Account.list()
       |> ExPersona.stream!()
       |> Stream.take(400)
       |> Enum.to_list()
       |> IO.inspect()
  """
  @spec list() :: Operation.t()
  def list, do: %Operation{path: "accounts", parser: Parser.list_parser(&Account.parse/1)}

  @doc """
  Get a specific `ExPersona.Account`.
  """
  @spec get(String.t()) :: Operation.t()
  def get(id), do: %Operation{path: "accounts/#{id}", parser: &Account.parse/1}

  @doc false
  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Account{data: data, id: data["id"]}}
end
