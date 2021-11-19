defmodule BlitzElixirProject do
  @moduledoc """
  Documentation for `BlitzElixirProject`.
  """

  def get_summoners(summoner_name, region) do
    api_key = Application.fetch_env!(:blitz_elixir_project, :riot_api_key)

    summoner_url =
      "https://#{region}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"

    {:ok, summoner} =
      case HTTPoison.get(summoner_url, [], params: [api_key: api_key]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          JSON.decode(body)

        error ->
          IO.inspect(error)
      end

    match_by_puuid_url =
      "https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{summoner["puuid"]}/ids"

    {:ok, match_ids} =
      case HTTPoison.get(match_by_puuid_url, [], params: [api_key: api_key, count: 5]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          JSON.decode(body)

        error ->
          IO.inspect(error)
      end

    matches =
      Enum.map(match_ids, fn each ->
        match_url = "https://americas.api.riotgames.com/lol/match/v5/matches/#{each}"

        {:ok, match} =
          case HTTPoison.get(match_url, [], params: [api_key: api_key]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              JSON.decode(body)

            error ->
              IO.inspect(error)
          end

        match
      end)

    Enum.flat_map(matches, fn each ->
      each["info"]["participants"] |> Enum.map(& &1["summonerName"])
    end)
    |> Enum.uniq()
  end
end
