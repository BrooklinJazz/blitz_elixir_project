defmodule BlitzElixirProject.RiotAPI do
  @moduledoc """
  API for retrieving Blogs.
  """
  @callback recent_competitor_names(String.t(), String.t()) :: [String.t()]
  def recent_competitor_names(summoner_name, routing_value, number_of_matches \\ 5),
    do: impl().recent_competitor_names(summoner_name, routing_value, number_of_matches)

  @callback get_summoner(String.t(), String.t()) :: map()
  def get_summoner(summoner_name, routing_value),
    do: impl().get_summoner(summoner_name, routing_value)

  @callback get_matches(String.t(), integer()) :: [map()]
  def get_matches(summoner_puuid, count), do: impl().get_matches(summoner_puuid, count)

  @callback last_completed_match_uuid(String.t()) :: String.t()
  def last_completed_match_uuid(summoner_puuid),
    do: impl().last_completed_match_uuid(summoner_puuid)

  defp impl,
    do: Application.get_env(:blitz_elixir_project, :riot_api, BlitzElixirProject.ProdRiotAPI)
end

defmodule BlitzElixirProject.ProdRiotAPI do
  alias BlitzElixirProject.RegionConverter
  alias BlitzElixirProject.Summoner
  alias BlitzElixirProject.HTTPThrottle

  def recent_competitor_names(summoner_name, routing_value, number_of_matches_to_include \\ 5) do
    with %Summoner{puuid: puuid} <- get_summoner(summoner_name, routing_value) do
      recent_match_uuids(puuid, number_of_matches_to_include)
      |> Enum.map(&match_from_match_uuid(&1, routing_value))
      |> Enum.flat_map(& &1["info"]["participants"])
      |> Enum.map(& &1["summonerName"])
      |> Enum.uniq()
    end
  end

  defp match_from_match_uuid(match_id, routing_value) do
    with {:ok, response} <-
           HTTPThrottle.get(
             "https://#{RegionConverter.to_region(routing_value)}.api.riotgames.com/lol/match/v5/matches/#{match_id}"
           ) do
      response
    end
  end

  def get_summoner(summoner_name, routing_value) do
    with {:ok, response} <-
           HTTPThrottle.get(
             "https://#{routing_value}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"
           ) do
      %Summoner{name: response["name"], puuid: response["puuid"]}
    end
  end

  def recent_match_uuids(summoner_puuid, count) do
    with {:ok, uuids} <-
           HTTPThrottle.get(
             "https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{summoner_puuid}/ids",
             count: count
           ) do
      uuids
    end
  end

  @doc """
  For the sake of this exercise, this fn simply returns the most recent match.
  In a future implementation, It could be expanded to check if this match is actually complete using the endTime field.
  If not complete, it would then return the match before the most recent one
  (assuming any match before a currently incomplete match is complete)
  """
  def last_completed_match_uuid(summoner_puuid) do
    case recent_match_uuids(summoner_puuid, 1) do
      {:error, error} -> {:error, error}
      [uuid] -> uuid
    end
  end
end
