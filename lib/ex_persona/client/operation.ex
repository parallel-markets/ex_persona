defmodule ExPersona.Client.Operation do
  @moduledoc """
  A description of a specific API call.
  """
  alias ExPersona.Client.Parser

  defstruct path: "/", type: :get, parser: &Parser.default_parse/1, params: []

  @type operation_type :: :get | :post | :patch | :delete

  @type t :: %__MODULE__{
          path: String.t(),
          type: operation_type(),
          parser: Parser.parser_func(),
          params: [{String.t(), String.t()}]
        }
end
