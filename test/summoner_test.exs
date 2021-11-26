defmodule BlitzElixirProject.SummonerTest do
  use ExUnit.Case

  import Mox

  alias BlitzElixirProject.Summoner
  require Logger

  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "Summoner" do
    test "sync_last_match/2" do
      BlitzElixirProject.MockRiotAPI
      |> expect(:last_completed_match_uuid, fn "fake_puuid" -> "new_fake" end)

      summoner = %Summoner{name: "fake_name", puuid: "fake_puuid", last_match: "fake"}
      assert %{last_match: last_match} = Summoner.sync_last_match(summoner)
    end
  end
end
