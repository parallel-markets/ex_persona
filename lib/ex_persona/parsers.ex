defmodule ExPersona.Parsers do
  def json(input), do: Jason.decode(input)

  def identity(input), do: input
end
