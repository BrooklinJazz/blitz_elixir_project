defmodule BlitzElixirProject.Monitor do
  use GenServer
  alias BlitzElixirProject.RiotAPI
  require Logger
  @kill_timeout 60000 * 60
  def start_link(summoner) do
    last_match = RiotAPI.last_completed_match_uuid(summoner["puuid"])

    GenServer.start_link(__MODULE__, %{
      summoner: %{puuid: summoner["puuid"], name: summoner["name"]},
      last_match: last_match
    })
  end

  def init(state) do
    Process.send_after(self(), :kill, @kill_timeout)
    {:ok, state}
  end

  def sync_last_match(pid) do
    GenServer.call(pid, :sync_last_match)
  end

  def handle_call(:sync_last_match, _from, state) do
    last_match = RiotAPI.last_completed_match_uuid(state.summoner.puuid)

    {:reply, %{last_match: last_match, updated: last_match !== state.last_match},
     %{state | last_match: last_match}}
  end

  def handle_info(:kill, state) do
    {:stop, :normal, state}
  end
end
