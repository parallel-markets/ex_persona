defmodule ExPersona do
  @moduledoc """
  Documentation for `ExPersona`.
  """

  def request(req), do: ExPersona.Client.request(req)
end
