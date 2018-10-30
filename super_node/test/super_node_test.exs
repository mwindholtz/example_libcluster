defmodule SuperNodeTest do
  use ExUnit.Case
  doctest SuperNode

  test "greets the world" do
    assert SuperNode.hello() == :world
  end
end
