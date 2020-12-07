defmodule ExPersona.ClientTest do
  use ExUnit.Case
  import Mock

  alias ExPersona.Client

  @testkey "thisisatestkeyanditisverylong"

  setup do
    Application.put_env(:ex_persona, :api_key, @testkey)
  end

  describe "When making GET requests" do
    test "Calling the API without a key should raise" do
      Application.delete_env(:ex_persona, :api_key)
      msg = "You must configure an :api_key for :ex_persona"

      assert_raise RuntimeError, msg, fn ->
        Client.get("", [], %{})
      end
    end

    test "Query params and headers should be handled" do
      url = "http://example.com"

      with_mock HTTPoison,
        get: fn rurl, rheaders ->
          assert rurl == "#{url}?test=value"

          assert rheaders == [
                   Authorization: "Bearer #{@testkey}",
                   Accept: "Application/json; Charset=utf-8",
                   "Key-Inflection": "snake",
                   one: "two"
                 ]

          {:ok, %HTTPoison.Response{body: "body", status_code: 200}}
        end do
        assert Client.get(url, [one: "two"], test: "value") == {:ok, "body", []}
      end
    end
  end
end
