defmodule ExPersona.Report do
  @moduledoc """
  Module for fetching specific [reports](https://docs.withpersona.com/reference#apiv1reportsreport-id).
  """

  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  @type t :: %__MODULE__{data: map(), id: String.t()}

  @doc """
  Get a specific `ExPersona.Report`.
  """
  @spec get(String.t()) :: Operation.t()
  def get(id), do: %Operation{path: "reports/#{id}", parser: &Report.parse/1}

  @doc false
  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Report{data: data, id: data["id"]}}
end
