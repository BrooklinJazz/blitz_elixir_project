defmodule BlitzElixirProject.Main do
  alias BlitzElixirProject.RiotAPI
  alias BlitzElixirProject.Summoner
  alias BlitzElixirProject.SummonerMonitorSupervisor
  alias BlitzElixirProject.SummonerMonitor

  def find_and_monitor_competitors(summoner_name, region) do
    summoner_names = RiotAPI.recent_competitor_names(summoner_name, region)

    Enum.map(summoner_names, &RiotAPI.get_summoner(&1, region))
    |> Enum.map(fn
      %Summoner{} = summoner -> Summoner.sync_last_match(summoner)
      _ -> nil
    end)
    |> Enum.reject(&is_nil(&1))
    |> Enum.each(fn summoner ->
      DynamicSupervisor.start_child(
        SummonerMonitorSupervisor,
        {SummonerMonitor, %{summoner: summoner}}
      )
    end)

    summoner_names
  end
end
