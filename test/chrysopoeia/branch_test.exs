defmodule Chrysopoeia.BranchTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Branch, as: Branch

  test "alt" do
    alias Chrysopoeia.Base.String, as: Str

    parser = Branch.alt([Str.tag("ab"), Str.tag("bc")])
    assert {:ok, "ab", ""} = parser.("ab")
    assert {:ok, "ab", "c"} = parser.("abc")
    assert {:ok, "bc", ""} = parser.("bc")
    assert {:ok, "bc", "ab"} = parser.("bcab")
    assert {:err, _} = parser.("cb")
    assert {:err, _} = parser.("")
  end
end
