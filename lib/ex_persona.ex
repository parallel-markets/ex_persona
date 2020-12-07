defmodule ExPersona do
  @moduledoc """
  This is an Elixir library for interacting with the [Persona](https://withpersona.com) platform.

  It handles streaming paginated lists of inquiries and accounts, and allows you to interact with the API
  with only a thin layer of Elixiry abstraction.
  """

  alias ExPersona.Client

  @doc """
  Send a given `ExPersona.Client.Operation` to the API endpoint.  

  This is the general entry point for all requests.
  """
  @spec request(Client.Operation.t()) :: Client.Parser.parsed_result()
  defdelegate request(req), to: ExPersona.Client

  @doc """
  Send a given `ExPersona.Client.Operation` to the API endpoint, raising if there's any error.
  """
  @spec request!(Client.Operation.t()) :: struct()
  defdelegate request!(req), to: ExPersona.Client

  @doc """
  Make a request, producing a `Stream` for paginating results.

  Send a given `ExPersona.Client.Operation` to the API endpoint with the expectation that the
  `ExPersona.Client.Operation` will produce a paginated result.  Any errors will raise an
  exception.
  """
  @spec stream!(Client.Operation.t()) :: Enumerable.t()
  defdelegate stream!(req), to: ExPersona.Client.Streamable
end
