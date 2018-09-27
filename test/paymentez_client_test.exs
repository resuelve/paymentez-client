defmodule PaymentezClientTest do
  use ExUnit.Case
  doctest PaymentezClient

  test "greets the world" do
    assert PaymentezClient.hello() == :world
  end
end
