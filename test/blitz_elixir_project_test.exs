defmodule BlitzElixirProjectTest do
  use ExUnit.Case
  doctest BlitzElixirProject

  test "greets the world" do
    assert BlitzElixirProject.hello() == :world
  end
end
