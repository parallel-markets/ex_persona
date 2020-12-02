defmodule ExPersona.Operation do
  alias ExPersona.Parsers

  defstruct path: "/", type: :get, parser: &Parsers.identity/1

  @type t :: %__MODULE__{}

  def identity_parse(result), do: result
end
