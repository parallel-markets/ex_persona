defmodule ExPersona.InquiryTest do
  use ExUnit.Case

  alias ExPersona.Inquiry
  alias ExPersona.Client.{Operation, Result}

  test "list should produce expected operation" do
    %Operation{path: path, type: :get, parser: parser} = Inquiry.list()
    assert path == "inquiries"

    data = [%{"id" => "one"}, %{"id" => "two"}]
    op = %Operation{}
    result = %Result{parsed: %{"data" => data, "links" => %{"next" => ""}}, operation: op}

    {:ok, [one, two], streamable} = parser.(result)
    assert one.data == %{"id" => "one"}
    assert one.id == "one"
    assert two.data == %{"id" => "two"}
    assert two.id == "two"

    assert streamable.closed
    assert is_nil(streamable.cursor)
    assert streamable.operation == op
  end

  test "get by id should produce expected operation" do
    %Operation{path: path, type: :get, parser: parser} = Inquiry.get("anid")
    assert path == "inquiries/anid"

    data = %{"id" => "one"}
    op = %Operation{}
    included = %{"something" => "else"}
    result = %Result{parsed: %{"data" => data, "included" => included, operation: op}}

    {:ok, inq} = parser.(result)
    assert inq.data == %{"id" => "one"}
    assert inq.id == "one"
    assert inq.included == included
  end

  test "get_document_ids should produce expected ids" do
    docs = [%{"id" => "1"}, %{"id" => "2"}]
    inq = %Inquiry{data: %{"relationships" => %{"documents" => %{"data" => docs}}}}
    assert Inquiry.get_document_ids(inq) == ["1", "2"]

    assert Inquiry.get_document_ids(%Inquiry{}) == []
  end
end
