defmodule ExPersona.Client.Streamable do
  @moduledoc """
  Handle streamable (i.e., paginated) responses from the API.
  """
  alias ExPersona.Client
  alias ExPersona.Client.Operation
  alias __MODULE__

  defstruct [:operation, :cursor, :closed]
  @type t :: %__MODULE__{operation: Operation.t(), cursor: String.t(), closed: boolean()}

  @doc """
  Produce a `Stream` for a given `ExPersona.Client.Operation`.

  For instance:

       # get 400 accounts
       ExPersona.Account.list()
       |> ExPersona.stream!()
       |> Stream.take(400)
       |> Enum.to_list()
       |> IO.inspect()
  """
  @spec stream!(Operation.t()) :: Enumerable.t()
  def stream!(%Operation{} = op),
    do: Stream.resource(fn -> start(op) end, &next/1, fn _ -> nil end)

  defp start(%Operation{} = op),
    do: %Streamable{operation: op, closed: false}

  defp next(%Streamable{closed: true} = st), do: {:halt, st}

  defp next(%Streamable{cursor: nil} = st),
    do: next_with_params(st, %{})

  defp next(%Streamable{cursor: cursor} = st),
    do: next_with_params(st, %{"page[after]" => cursor})

  defp next_with_params(%Streamable{operation: op}, params) do
    case Client.request(%Operation{op | params: params}) do
      {:ok, result, stream} ->
        {result, stream}

      err ->
        raise RuntimeError, message: err
    end
  end
end
