defmodule Chrysopoeia.HelperTest do
  use ExUnit.Case, async: true

  alias Chrysopoeia.Helper, as: Helper

  test "countdown" do
    assert 5 = Helper.countdown(6)
    assert 0 = Helper.countdown(1)
    assert 0 = Helper.countdown(0)
    assert 0 = Helper.countdown(-10)
  end
end
