defmodule Chrysopoeia.Combinator do
  @moduledoc """
  Core combinators.
  """

  @doc """
  Applies `fun` to the result of `parser` on success.
  """
  def map(parser, fun) do
    fn str ->
      with {:ok, value, str} <- parser.(str) do
        {:ok, fun.(value), str}
      end
    end
  end

  @doc """
  Parser that always succeeds, and consumes nothing.
  """
  def success(str) do
    {:ok, str}
  end

  @doc """
  Parser that always errors.
  """
  def failure(_str) do
    {:err, "Bad parse"}
  end

  @doc """
  Combinator that adds a condition to an existing parser.

  If `fun` is true, return the value. Otherwise, return an error.
  The error message is optional.
  """
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
