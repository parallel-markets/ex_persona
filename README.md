# ExPersona
[![Build Status](https://github.com/parallel-markets/ex_persona/workflows/ci/badge.svg)](https://github.com/parallel-markets/ex_persona)
[![Hex pm](http://img.shields.io/hexpm/v/ex_persona.svg?style=flat)](https://hex.pm/packages/ex_persona)
[![API Docs](https://img.shields.io/badge/api-docs-lightgreen.svg?style=flat)](https://hexdocs.pm/ex_persona/)

This is an Elixir library for interacting with the [Persona](https://withpersona.com) platform.

## Installation
The package can be installed by adding `ex_persona` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_persona, "~> 0.1.0"}
  ]
end
```

Check [Hex](https://hex.pm/packages/ex_persona) to make sure you're using an up-to-date version number.

## Usage

You'll need your API key (this can be found on your dashboard on [withpersona.com](https://withpersona.com/dashboard)).  You should set this API key in your configuration:

```
config :ex_persona, api_key: "persona_production_123123123"
```

Then, you can build and send requests.

```elixir
# To stream all inquiries, paginating behind the scenes:
ExPersona.Inquiry.list()
|> ExPersona.stream!()
|> Stream.take(100)
|> Enum.to_list()

# To get a specific inquiry by ID:
inq = ExPersona.Inquiry.get("inq_adsf123asfd") |> ExPersona.request!()

# Download all the front photos of the documents for an inquiry
inq
|> ExPersona.Inquiry.get_document_ids()
|> Enum.map(&ExPersona.Document.get/1)
|> Enum.map(&ExPersona.request!/1)
|> Enum.map(& ExPersona.Document.download_file(&1, "front_photo"))
```

See the [list of modules](https://hexdocs.pm/ex_persona/api-reference.html#modules) for a list of the other types (Verifications, Accounts, Reports, etc) available.

## Running Tests

To run tests:

```shell
$ mix test
```

## Reporting Issues

Please report all issues [on github](https://github.com/parallel-markets/ex_persona/issues).
