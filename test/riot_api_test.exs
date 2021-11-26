defmodule BlitzElixirProject.RiotApiTest do
  use ExUnit.Case
  alias BlitzElixirProject.RiotAPI
  alias BlitzElixirProject.ProdRiotAPI
  alias BlitzElixirProject.Summoner

  @moduletag :prod

  @valid_summoner_name "Sn1per1"
  @valid_region "na1"

  setup_all do
    Application.put_env(:blitz_elixir_project, :riot_api, ProdRiotAPI)
    :ok
  end

  test "recent_competitor_names/2" do
    assert summoners = RiotAPI.recent_competitor_names(@valid_summoner_name, @valid_region)

    assert Enum.all?(summoners, &is_bitstring(&1))
  end

  test "get_summoner/2" do
    assert %Summoner{name: @valid_summoner_name, puuid: _puuid, last_match: nil} =
             RiotAPI.get_summoner(@valid_summoner_name, @valid_region)
  end

  test "last_completed_match_uuid/1" do
    %{puuid: summoner_puuid} = RiotAPI.get_summoner(@valid_summoner_name, @valid_region)
    assert match_uuid = RiotAPI.last_completed_match_uuid(summoner_puuid)
    assert is_bitstring(match_uuid)
  end
end
