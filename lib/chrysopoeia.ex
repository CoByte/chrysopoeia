defmodule Chrysopoeia do
  use ExUnit.Case, async: true

  @moduledoc """
  `Chrysopoeia` is a parser combinator library heavily inspired by Rust's nom.

  It mainly exists as a learning tool for fun :).
  """

  test "kv pair" do
    alias Chrysopoeia.Base.String, as: Str
    alias Chrysopoeia.Sequence, as: Seq

    str = "key: value"

    Seq
  end
end
