defmodule ExPersona.Client.Streamable do
  defstruct [:operation, :cursor, :closed]

  alias ExPersona.Client
  alias ExPersona.Client.Operation
  alias __MODULE__

  def stream!(%Operation{} = op),
    do: Stream.resource(fn -> start(op) end, &next/1, fn _ -> nil end)

  def start(%Operation{} = op),
    do: %Streamable{operation: op, closed: false}

  def next(%Streamable{closed: true} = st), do: {:halt, st}

  def next(%Streamable{cursor: nil} = st),
    do: next_with_params(st, %{})

  def next(%Streamable{cursor: cursor} = st),
    do: next_with_params(st, %{"page[after]" => cursor})

  defp next_with_params(%Streamable{operation: op}, params) do
    case Client.request(op, params) do
      {:ok, result, stream} ->
        {result, stream}

      err ->
        raise RuntimeError, message: err
    end
  end
end
