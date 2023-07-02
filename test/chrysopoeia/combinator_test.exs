defmodule Chrysopoeia.CombinatorTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Combinator, as: Comb

  test "map" do
    alias Chrysopoeia.Base.String, as: Str
    alias Chrysopoeia.Multi, as: Multi
    alias Chrysopoeia.Sequence, as: Seq

    parser1 =
      Str.tag("abc")
      |> Comb.map(&String.upcase(&1, :ascii))

    assert {:ok, "ABC", ""} = parser1.("abc")
    assert {:ok, "ABC", "def"} = parser1.("abcdef")
    assert {:err, _} = parser1.("defg")

    parser2 =
      Multi.many(Str.tag("a"))
      |> Comb.map(&Enum.count/1)

    assert {:ok, 3, ""} = parser2.("aaa")
    assert {:ok, 3, "bba"} = parser2.("aaabba")
    assert {:ok, 0, "defg"} = parser2.("defg")

    parser3 =
      Seq.list([Str.tag("a"), Str.tag("b"), Str.tag("c")])
      |> Comb.map(&Enum.join/1)

    assert {:ok, "abc", ""} = parser3.("abc")
    assert {:ok, "abc", "def"} = parser3.("abcdef")
    assert {:err, _} = parser3.("aabc")
  end

  test "success" do
    parser = Comb.success()
    assert {:ok, nil, "asdf"} = parser.("asdf")
    assert {:ok, nil, ""} = parser.("")
  end

  test "failure" do
    parser = Comb.failure()
    assert {:err, _} = parser.("asdf")
    assert {:err, _} = parser.("")
  end
end
