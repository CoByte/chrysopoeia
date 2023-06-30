defmodule Chrysopoeia.CharacterTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Character, as: Char

  test "tag" do
    parser = Char.tag("asdf")
    assert {:ok, "asdf", ""} = parser.("asdf")
    assert {:ok, "asdf", "qwer"} = parser.("asdfqwer")
    assert {:err, _} = parser.("sdfg")
    assert {:err, _} = parser.(" asdf")
    assert {:err, _} = parser.("")
  end

  test "whitespace" do
    assert {:ok, " ", ""} = Char.whitespace(" ")
    assert {:ok, "\n", ""} = Char.whitespace("\n")
    assert {:ok, "\r", ""} = Char.whitespace("\r")
    assert {:ok, "\t", ""} = Char.whitespace("\t")
    assert {:ok, " ", "asdf"} = Char.whitespace(" asdf")
    assert {:ok, " ", " "} = Char.whitespace("  ")
    assert {:err, _} = Char.whitespace("asdf")
    assert {:err, _} = Char.whitespace("a ")
  end

  test "is_alpha?" do
    assert true == Char.is_alpha?("a")
    assert true == Char.is_alpha?("Z")
    assert false == Char.is_alpha?(" ")
  end

  test "alpha" do
    assert {:ok, "asdf", ""} = Char.alpha("asdf")
    assert {:ok, "asdf", " asdf"} = Char.alpha("asdf asdf")
    assert {:ok, "", "1asdf"} = Char.alpha("1asdf")
    assert {:ok, "ASDF", ""} = Char.alpha("ASDF")

    alphabet =
      Stream.concat(?A..?Z, ?a..?z)
      |> Enum.to_list()
      |> List.to_string()

    assert {:ok, ^alphabet, ""} = Char.alpha(alphabet)
  end
end
