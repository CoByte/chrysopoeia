defmodule Chrysopoeia.Base.StringTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Base.String, as: Str

  test "tag" do
    parser = Str.tag("asdf")
    assert {:ok, "asdf", ""} = parser.("asdf")
    assert {:ok, "asdf", "qwer"} = parser.("asdfqwer")
    assert {:err, _} = parser.("sdfg")
    assert {:err, _} = parser.(" asdf")
    assert {:err, _} = parser.("")
  end
end
