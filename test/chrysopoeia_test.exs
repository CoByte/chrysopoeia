defmodule ChrysopoeiaTest do
  use ExUnit.Case, async: true

  test "parse KV pair" do
    alias Chrysopoeia.Sequence, as: Seq
    alias Chrysopoeia.Base.Codepoint, as: Code
    alias Chrysopoeia.Base.String, as: Str
    alias Chrysopoeia.Combinator, as: Comb

    parse_word =
      Code.take_while(&Code.is_alphanum?/1)
      |> Comb.map(&List.to_string/1)

    parser =
      Seq.list([
        parse_word,
        {:ig, Str.tag(": ")},
        parse_word
      ])

    assert {:ok, ["key", "value"], ""} = parser.("key: value")
    assert {:ok, ["key", "1234"], ""} = parser.("key: 1234")
    assert {:ok, ["1234", "value"], ""} = parser.("1234: value")
    assert {:ok, ["key", "value"], " more stuff"} = parser.("key: value more stuff")
    assert {:err, _} = parser.("key value")
    assert {:err, _} = parser.("keyvalue")
  end
end
