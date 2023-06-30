defmodule Chrysopoeia.BranchTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Branch, as: Branch

  test "alt" do
    alias Chrysopoeia.Character, as: Char

    parser = Branch.alt([Char.tag("ab"), Char.tag("bc")])
    assert {:ok, "ab", ""} = parser.("ab")
    assert {:ok, "ab", "c"} = parser.("abc")
    assert {:ok, "bc", ""} = parser.("bc")
    assert {:ok, "bc", "ab"} = parser.("bcab")
    assert {:err, _} = parser.("cb")
    assert {:err, _} = parser.("")
  end
end
