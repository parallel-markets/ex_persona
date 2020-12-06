defmodule ExPersona.Client.Operation do
  alias ExPersona.Client.Parser

  defstruct path: "/", type: :get, parser: &Parser.default_parse/1, params: []

  @type t :: %__MODULE__{}
end
