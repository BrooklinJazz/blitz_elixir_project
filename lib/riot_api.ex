defmodule BlitzElixirProject.RiotAPI do
  @moduledoc """
  API for retrieving Blogs.
  """
  @callback get_summoners(String.t(), String.t()) :: [String.t()]
  def get_summoners(summoner_name, region), do: impl().get_summoners(summoner_name, region)

  @callback get_summoner(String.t(), String.t()) :: map()
  def get_summoner(summoner_name, region), do: impl().get_summoner(summoner_name, region)

  @callback get_matches(String.t(), integer()) :: [map()]
  def get_matches(summoner_puuid, count), do: impl().get_matches(summoner_puuid, count)

  @callback last_completed_match_uuid(String.t()) :: String.t()
  def last_completed_match_uuid(summoner_puuid),
    do: impl().last_completed_match_uuid(summoner_puuid)

  defp impl,
    do: Application.get_env(:blitz_elixir_project, :riot_api, BlitzElixirProject.ProdRiotAPI)
end

defmodule BlitzElixirProject.ProdRiotAPI do
  defp api_key do
    Application.fetch_env!(:blitz_elixir_project, :riot_api_key)
  end

  def get_summoners(summoner_name, region) do
    get_summoner(summoner_name, region)["puuid"]
    |> recent_match_uuids(5)
    |> Enum.map(&match_from_match_uuid/1)
    |> Enum.flat_map(& &1["info"]["participants"])
    |> Enum.map(& &1["summonerName"])
    |> Enum.uniq()
  end

  defp match_from_match_uuid(match_id) do
    match_url = "https://americas.api.riotgames.com/lol/match/v5/matches/#{match_id}"

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(match_url, [], params: [api_key: api_key()]),
         {:ok, match} <- JSON.decode(body) do
      match
    end
  end

  def get_summoner(summoner_name, region) do
    summoner_url =
      "https://#{region}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(summoner_url, [], params: [api_key: api_key()]),
         {:ok, response} <- JSON.decode(body) do
      response
    end
  end

  def recent_match_uuids(summoner_puuid, count) do
    match_ids_by_puuids =
      "https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{summoner_puuid}/ids"

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(match_ids_by_puuids, [], params: [api_key: api_key(), count: count]),
         {:ok, response} <- JSON.decode(body) do
      response
    end
  end

  @doc """
  For the sake of this exercise, this fn simply returns the most recent match.
  In a future implementation, It could be expanded to check if this match is actually complete using the endTime field.
  If not complete, it would then return the match before the most recent one
  (assuming any match before a currently incomplete match is complete)
  """
  def last_completed_match_uuid(summoner_puuid) do
    summoner_puuid |> recent_match_uuids(1) |> hd()
  end
end
