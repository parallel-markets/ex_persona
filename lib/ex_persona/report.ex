defmodule ExPersona.Report do
  alias ExPersona.Client.{Operation, Result}
  alias __MODULE__

  defstruct [:data, :id]

  def get(id), do: %Operation{path: "reports/#{id}", parser: &Report.parse/1}

  def parse(%Result{parsed: %{"data" => data}}),
    do: {:ok, %Report{data: data, id: data["id"]}}
end
