defmodule BlitzElixirProject.MonitorTest do
  use ExUnit.Case

  import Mox
  import ExUnit.CaptureLog

  alias BlitzElixirProject.Monitor
  alias BlitzElixirProject.RiotAPI

  require Logger

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "sync_last_match/2" do
    BlitzElixirProject.MockRiotAPI
    |> expect(:get_summoner, fn _, _ ->
      %{"name" => "Sn1per1", "puuid" => "fake_Sn1per1_puuid"}
    end)
    |> expect(:last_completed_match_uuid, fn "fake_Sn1per1_puuid" -> "previous" end)
    |> expect(:last_completed_match_uuid, fn "fake_Sn1per1_puuid" -> "current" end)

    summoner = RiotAPI.get_summoner("Sn1per1", "na1")

    {:ok, monitor} = Monitor.start_link(summoner)

    %{updated: true, last_match: "current"} = Monitor.sync_last_match(monitor)
  end
end
