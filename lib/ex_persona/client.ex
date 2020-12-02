defmodule ExPersona.Client do
  alias ExPersona.Operation

  @api_location "https://withpersona.com/api"
  @api_version "v1"

  def request(%Operation{type: :get, path: path, parser: parser}) do
    path
    |> make_url()
    |> get()
    |> case do
      {:ok, body} ->
        parser.(body)

      error ->
        error
    end
  end

  def get(url, headers \\ []) do
    req_headers =
      Keyword.merge(
        [
          Authorization: "Bearer " <> get_api_key(),
          Accept: "Application/json; Charset=utf-8",
          "Key-Inflection": "snake"
        ],
        headers
      )

    case HTTPoison.get(url, req_headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "API returned #{code}"}

      {:error, error} ->
        {:error, HTTPoison.Error.message(error)}
    end
  end

  defp make_url(path) do
    Path.join([@api_location, @api_version, path])
  end

  defp get_api_key do
    api_key = Application.get_env(:ex_persona, :api_key)

    if is_nil(api_key) do
      raise RuntimeError, message: "You must configure an :api_key for :persona"
    else
      api_key
    end
  end
end
