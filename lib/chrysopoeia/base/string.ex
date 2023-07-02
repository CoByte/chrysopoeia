defmodule Chrysopoeia.Base.String do
  @moduledoc """
  Base module for parsing strings.
  """

  alias Chrysopoeia, as: Chr

  @doc """
  A combinator that consumes `prefix` from the start of `input` if it matches.
  """
  @spec tag(String.t()) :: Chr.parser(String.t(), String.t(), any())
  def tag(prefix) do
    fn str ->
      if String.starts_with?(str, prefix) do
        # algorithm taken from
        # [[https://hexdocs.pm/elixir/1.12/String.html#module-string-and-binary-operations]]
        base = byte_size(prefix)
        rem = binary_part(str, base, byte_size(str) - base)
        {:ok, prefix, rem}
      else
        {:err, "Parse Error: \"#{prefix}\" does not match"}
      end
    end
  end
end
