defmodule Chrysopoeia.MultiTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Multi, as: Multi

  test "many" do
    alias Chrysopoeia.Base.String, as: Str

    parser1 = Multi.many(Str.tag("ab"))
    assert {:ok, ["ab", "ab"], ""} = parser1.("abab")
    assert {:ok, ["ab", "ab"], "a"} = parser1.("ababa")
    assert {:ok, [], "baba"} = parser1.("baba")

    parser2 = Multi.many(Str.tag("ab"), count: 2)
    assert {:ok, ["ab", "ab"], ""} = parser2.("abab")
    assert {:err, _} = parser2.("aba")
  end

  test "many_until" do
    alias Chrysopoeia.Base.String, as: Str

    parser = Multi.many_until(Str.tag("ab"), Str.tag("end"))
    assert {:ok, ["ab", "ab"], "end"} = parser.("ababend")
    assert {:ok, [], "end"} = parser.("end")
    assert {:err, _} = parser.("abab")
    assert {:err, _} = parser.("ababnotend")
    assert {:err, _} = parser.("")
  end
end
