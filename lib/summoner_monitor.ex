defmodule BlitzElixirProject.SummonerMonitor do
  use GenServer
  alias BlitzElixirProject.Summoner
  require Logger
  @minute 1000 * 60
  @hour @minute * 60

  def start_link(%{summoner: %Summoner{puuid: puuid}} = opts) do
    # if there are too many summoners names active in the system
    # this could cause an atom overload.
    GenServer.start_link(__MODULE__, opts, name: String.to_atom(puuid))
  end

  def init(opts) do
    Process.send(self(), :monitor, [])
    Process.send_after(self(), :kill, Map.get(opts, :timeout, @hour))
    {:ok, opts}
  end

  def handle_info(:monitor, %{summoner: summoner} = state) do
    Process.send_after(self(), :monitor, @minute)
    updated_summoner = Summoner.sync_last_match(summoner)

    if summoner.last_match !== updated_summoner.last_match do
      Logger.info(
        "summoner: #{updated_summoner.name} completed match: #{updated_summoner.last_match}"
      )
    else
      Logger.info("no update for #{updated_summoner.name}")
    end

    {:noreply, %{state | summoner: updated_summoner}}
  end

  def handle_info(:kill, state) do
    {:stop, :normal, state}
  end
end
