defmodule Chrysopoeia.Combinator do
  @moduledoc """
  Core combinators for general use.
  """

  alias Chrysopoeia, as: Chr

  @doc """
  Applies `fun` to the result of `parser` on success.
  """
  @spec map(Chr.parser(i, t, e), (t -> m)) :: Chr.parser(i, m, e)
        when i: var, t: var, m: var, e: var
  def(map(parser, fun)) do
    fn str ->
      with {:ok, value, str} <- parser.(str) do
        {:ok, fun.(value), str}
      end
    end
  end

  @doc """
  Parser that always succeeds, and consumes nothing.
  """
  @spec success() :: (i -> {:ok, nil, i})
        when i: var
  def success() do
    fn str -> {:ok, nil, str} end
  end

  @doc """
  Parser that always errors.
  """
  @spec failure() :: (any() -> {:err, any()})
  def failure() do
    fn _str -> {:err, "Bad parse"} end
  end

  @doc """
  Combinator that adds a condition to an existing parser.

  If `fun` is true, return the value. Otherwise, return an error.
  The error message is optional.
  """
  @spec condition(Chr.parser(i, o, e1), (o -> boolean()), err_msg: e2) ::
          Chr.parser(i, o, e1 | e2)
        when i: var, o: var, e1: var, e2: var
  def condition(parser, fun, opts \\ [err_msg: "Condition was not met"]) do
    fn str ->
      with {:ok, value, str} <- parser.(str) do
        if fun.(value) do
          {:ok, value, str}
        else
          {:err, opts[:err_msg]}
        end
      end
    end
  end
end
