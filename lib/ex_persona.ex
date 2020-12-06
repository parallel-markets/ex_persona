defmodule ExPersona do
  @moduledoc """
  Documentation for `ExPersona`.
  """

  defdelegate request(req), to: ExPersona.Client

  defdelegate request!(req), to: ExPersona.Client

  defdelegate stream!(req), to: ExPersona.Client.Streamable
end
