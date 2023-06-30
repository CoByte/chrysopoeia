defmodule Chrysopoeia.CombinatorTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Combinator, as: Comb

  test "map" do
    alias Chrysopoeia.Character, as: Char
    alias Chrysopoeia.Multi, as: Multi
    alias Chrysopoeia.Sequence, as: Seq

    parser1 =
      Char.tag("abc")
      |> Comb.map(&String.upcase(&1, :ascii))

    assert {:ok, "ABC", ""} = parser1.("abc")
    assert {:ok, "ABC", "def"} = parser1.("abcdef")
    assert {:err, _} = parser1.("defg")

    parser2 =
      Multi.many(Char.tag("a"))
      |> Comb.map(&Enum.count/1)

    assert {:ok, 3, ""} = parser2.("aaa")
    assert {:ok, 3, "bba"} = parser2.("aaabba")
    assert {:ok, 0, "defg"} = parser2.("defg")

    parser3 =
      Seq.list([Char.tag("a"), Char.tag("b"), Char.tag("c")])
      |> Comb.map(&Enum.join/1)

    assert {:ok, "abc", ""} = parser3.("abc")
    assert {:ok, "abc", "def"} = parser3.("abcdef")
    assert {:err, _} = parser3.("aabc")
  end

  test "success" do
    assert {:ok, "asdf"} = Comb.success("asdf")
    assert {:ok, ""} = Comb.success("")
  end

  test "failure" do
    assert {:err, _} = Comb.failure("asdf")
    assert {:err, _} = Comb.failure("")
  end
end
