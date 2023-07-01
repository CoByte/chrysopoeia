defmodule Chrysopoeia.SequenceTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Sequence, as: Seq

  test "list" do
    alias Chrysopoeia.Base.String, as: Str

    parser1 =
      Seq.list([
        Str.tag("a"),
        Str.tag("b"),
        Str.tag("c")
      ])

    assert {:ok, ["a", "b", "c"], ""} = parser1.("abc")
    assert {:ok, ["a", "b", "c"], "def"} = parser1.("abcdef")
    assert {:err, _} = parser1.("defabc")
    assert {:err, _} = parser1.("ab")

    parser2 =
      Seq.list([
        Str.tag("a"),
        {:ig, Str.tag("b")},
        Str.tag("c")
      ])

    assert {:ok, ["a", "c"], ""} = parser2.("abc")
    assert {:ok, ["a", "c"], "def"} = parser2.("abcdef")
    assert {:err, _} = parser2.("defabc")
    assert {:err, _} = parser2.("ab")
  end

  test "prefix" do
    alias Chrysopoeia.Base.String, as: Str

    parser = Seq.prefix(Str.tag("ab"), Str.tag("cd"))
    assert {:ok, "cd", ""} = parser.("abcd")
    assert {:ok, "cd", "ef"} = parser.("abcdef")
    assert {:err, _} = parser.("abc")
    assert {:err, _} = parser.("a")
  end

  test "suffix" do
    alias Chrysopoeia.Base.String, as: Str

    parser = Seq.suffix(Str.tag("ab"), Str.tag("cd"))
    assert {:ok, "ab", ""} = parser.("abcd")
    assert {:ok, "ab", "ef"} = parser.("abcdef")
    assert {:err, _} = parser.("abc")
    assert {:err, _} = parser.("acd")
  end
end
