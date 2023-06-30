defmodule Chrysopoeia.MultiTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Multi, as: Multi

  test "many" do
    alias Chrysopoeia.Character, as: Char

    parser1 = Multi.many(Char.tag("ab"))
    assert {:ok, ["ab", "ab"], ""} = parser1.("abab")
    assert {:ok, ["ab", "ab"], "a"} = parser1.("ababa")
    assert {:ok, [], "baba"} = parser1.("baba")

    parser2 = Multi.many(Char.tag("ab"), count: 2)
    assert {:ok, ["ab", "ab"], ""} = parser2.("abab")
    assert {:err, _} = parser2.("aba")
  end

  test "many_until" do
    alias Chrysopoeia.Character, as: Char

    parser = Multi.many_until(Char.tag("ab"), Char.tag("end"))
    assert {:ok, ["ab", "ab"], "end"} = parser.("ababend")
    assert {:ok, [], "end"} = parser.("end")
    assert {:err, _} = parser.("abab")
    assert {:err, _} = parser.("ababnotend")
    assert {:err, _} = parser.("")
  end
end
