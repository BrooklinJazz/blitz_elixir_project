defmodule BlitzElixirProject.MainTest do
  use ExUnit.Case
  alias BlitzElixirProject.Main
  alias BlitzElixirProject.ProdRiotAPI
  alias BlitzElixirProject.SummonerMonitor
  alias BlitzElixirProject.SummonerMonitorSupervisor

  @moduletag :prod

  @valid_summoner_name "Sn1per1"
  @valid_region "na1"

  setup_all do
    Application.put_env(:blitz_elixir_project, :riot_api, ProdRiotAPI)
    :ok
  end

  test "find_and_monitor_competitors/1" do
    summoners = Main.find_and_monitor_competitors(@valid_summoner_name, @valid_region)

    %{active: active_monitors} = DynamicSupervisor.count_children(SummonerMonitorSupervisor)
    assert length(summoners) <= active_monitors
  end
end
