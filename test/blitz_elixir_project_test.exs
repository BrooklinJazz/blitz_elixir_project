defmodule BlitzElixirProjectTest do
  use ExUnit.Case
  doctest BlitzElixirProject

  describe "BlitzElixirProject" do
    @tag :prod
    test "get_summoners/2" do
      assert [summoner_name | _] = BlitzElixirProject.get_summoners("Sn1per1", "na1")
      assert is_bitstring(summoner_name)
    end
  end
end
