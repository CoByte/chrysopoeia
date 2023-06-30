defmodule Chrysopoeia.SequenceTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Sequence, as: Seq

  test "list" do
    alias Chrysopoeia.Character, as: Char

    parser =
      Seq.list([
        Char.tag("a"),
        Char.tag("b"),
        Char.tag("c")
      ])

    assert {:ok, ["a", "b", "c"], ""} = parser.("abc")
    assert {:ok, ["a", "b", "c"], "def"} = parser.("abcdef")
    assert {:err, _} = parser.("defabc")
    assert {:err, _} = parser.("ab")
  end

  test "prefix" do
    alias Chrysopoeia.Character, as: Char

    parser = Seq.prefix(Char.tag("ab"), Char.tag("cd"))
    assert {:ok, "cd", ""} = parser.("abcd")
    assert {:ok, "cd", "ef"} = parser.("abcdef")
    assert {:err, _} = parser.("abc")
    assert {:err, _} = parser.("a")
  end

  test "suffix" do
    alias Chrysopoeia.Character, as: Char

    parser = Seq.suffix(Char.tag("ab"), Char.tag("cd"))
    assert {:ok, "ab", ""} = parser.("abcd")
    assert {:ok, "ab", "ef"} = parser.("abcdef")
    assert {:err, _} = parser.("abc")
    assert {:err, _} = parser.("acd")
  end
end
