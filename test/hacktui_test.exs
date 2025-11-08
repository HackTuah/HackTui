defmodule HacktuiTest do
  use ExUnit.Case
  doctest Hacktui

  test "greets the world" do
    assert Hacktui.hello() == :world
  end
end
