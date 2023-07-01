defmodule Chrysopoeia.Base.CodepointTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Base.Codepoint, as: Code

  test "is_alpha?" do
    assert true == Code.is_alpha?(?a)
    assert false == Code.is_alpha?(?1)

    assert true ==
             Enum.concat(?a..?z, ?A..?Z)
             |> Enum.all?(&Code.is_alpha?/1)
  end

  test "is_whitespace?" do
    assert true == Code.is_whitespace?(32)
    assert true == Code.is_whitespace?(?\n)
    assert true == Code.is_whitespace?(?\n)
    assert true == Code.is_whitespace?(?\t)
    assert false == Code.is_whitespace?(?a)
  end

  test "is_digit" do
    assert true == Code.is_digit?(?1)
    assert false == Code.is_digit?(?a)

    assert true == ?0..?9 |> Enum.all?(&Code.is_digit?/1)
  end

  test "is_alphanum?" do
    assert true == Code.is_alphanum?(?a)
    assert true == Code.is_alphanum?(?0)
    assert false == Code.is_digit?(?!)

    assert true ==
             Enum.concat([?a..?z, ?A..?Z, ?0..?9])
             |> Enum.all?(&Code.is_alphanum?/1)
  end

  test "first" do
    assert {:ok, ?a, "sdf"} = Code.first("asdf")
    assert {:err, _} = Code.first("")
  end

  test "first_if" do
    parser = Code.first_if(&Code.is_digit?/1)
    assert {:ok, ?1, "234"} = parser.("1234")
    assert {:err, _} = parser.("asdf")
  end

  test "take" do
    parser = Code.take(2)
    assert {:ok, ~c"as", "df"} = parser.("asdf")
    assert {:err, _} = parser.("a")
  end

  test "take_while" do
    parser = Code.take_while(&Code.is_digit?/1)
    assert {:ok, ~c"12", ""} = parser.("12")
    assert {:ok, ~c"12", "df"} = parser.("12df")
    assert {:ok, ~c"12", "df34"} = parser.("12df34")
    assert {:ok, ~c"", ""} = parser.("")
    assert {:ok, ~c"", "asdf"} = parser.("asdf")
  end
end
