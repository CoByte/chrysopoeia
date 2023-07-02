defmodule Chrysopoeia do
  @moduledoc """
  `Chrysopoeia` is a parser combinator library heavily inspired by Rust's nom.

  It mainly exists as a learning tool for fun :).
  """

  @typedoc """
  A function that takes one argument, either parses it into data, or fails with
  an error.
  """
  @type parser(i, o, e) :: (i -> {:ok, o, i} | {:err, e})

  @typedoc """
  A function that creates new parsers
  """
  @type combinator(i, o, e) :: (... -> parser(i, o, e))
end
