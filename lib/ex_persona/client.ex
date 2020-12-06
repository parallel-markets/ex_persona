defmodule ExPersona.Client do
  alias ExPersona.Client.{Operation, Result}

  @api_location "https://withpersona.com/api"
  @api_version "v1"

  def request(%Operation{type: :get, path: path, parser: parser} = op, params \\ %{}) do
    path
    |> make_url()
    |> get([], params)
    |> case do
      {:ok, body, headers} ->
        parser.(Result.from_encoded(body, headers, op))

      error ->
        error
    end
  end

  def request!(req) do
    case request(req) do
      {:ok, result} ->
        result

      {:ok, result, _streamable} ->
        result

      {:error, error} ->
        raise RuntimeError, message: error
    end
  end

  def get(url, headers \\ [], params \\ []) do
    req_headers =
      Keyword.merge(
        [
          Authorization: "Bearer " <> get_api_key(),
          Accept: "Application/json; Charset=utf-8",
          "Key-Inflection": "snake"
        ],
        headers
      )

    url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> to_string()
    |> HTTPoison.get(req_headers)
    |> case do
      {:ok, %HTTPoison.Response{body: body, status_code: 200, headers: headers}} ->
        {:ok, body, headers}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "API returned #{code}"}

      {:error, error} ->
        {:error, HTTPoison.Error.message(error)}
    end
  end

  defp make_url("https://" <> _ = url), do: url

  defp make_url(path),
    do: Path.join([@api_location, @api_version, path])

  defp get_api_key do
    api_key = Application.get_env(:ex_persona, :api_key)

    if is_nil(api_key) do
      raise RuntimeError, message: "You must configure an :api_key for :persona"
    else
      api_key
    end
  end
end
