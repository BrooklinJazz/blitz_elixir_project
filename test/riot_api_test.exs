defmodule BlitzElixirProject.RiotApiTest do
  use ExUnit.Case
  doctest BlitzElixirProject
  alias BlitzElixirProject.ProdRiotAPI

  @tag :prod
  test "get_summoners/2" do
    assert [summoner_name | _] = ProdRiotAPI.get_summoners("Sn1per1", "na1")
    assert is_bitstring(summoner_name)
  end

  @tag :prod
  test "last_completed_match_uuid/1" do
    %{"puuid" => summoner_puuid} = ProdRiotAPI.get_summoner("Sn1per1", "na1")
    assert match_uuid = ProdRiotAPI.last_completed_match_uuid(summoner_puuid)
    assert is_bitstring(match_uuid)
  end
end
