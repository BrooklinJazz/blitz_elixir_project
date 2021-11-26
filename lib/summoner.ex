defmodule BlitzElixirProject.Summoner do
  @enforce_keys [:name, :puuid]
  defstruct @enforce_keys ++ [last_match: nil]

  alias BlitzElixirProject.RiotAPI

  def sync_last_match(%__MODULE__{} = summoner) do
    case RiotAPI.last_completed_match_uuid(summoner.puuid) do
      {:error, _} -> summoner
      last_match -> %__MODULE__{summoner | last_match: last_match}
    end
  end
end
