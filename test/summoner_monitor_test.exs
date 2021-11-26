defmodule BlitzElixirProject.SummonerMonitorTest do
  use ExUnit.Case
  import Mox
  import ExUnit.CaptureLog

  alias BlitzElixirProject.Factory
  alias BlitzElixirProject.SummonerMonitor
  alias BlitzElixirProject.Summoner

  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "SummonerMonitor" do
    test "start_link" do
      {:ok, _} =
        SummonerMonitor.start_link(%{
          summoner: %Summoner{name: "fake_name", puuid: "fake_puuid", last_match: nil}
        })
    end

    test "start_link twice with same summoner" do
      summoner = Factory.summoner()

      {:ok, monitor1} =
        SummonerMonitor.start_link(%{
          summoner: summoner
        })

      {:error, {:already_started, monitor2}} =
        SummonerMonitor.start_link(%{
          summoner: summoner
        })

      assert monitor1 === monitor2
    end

    test "handle_info(:monitor) _ last match is the same" do
      {:ok, monitor} =
        SummonerMonitor.start_link(%{
          summoner: %Summoner{
            name: "fake_name",
            puuid: "fake_puuid",
            last_match: "same_match"
          }
        })

      BlitzElixirProject.MockRiotAPI
      |> expect(:last_completed_match_uuid, fn "fake_puuid" -> "same_match" end)

      refute capture_log(fn ->
               Process.send(monitor, :monitor, [])
               assert %{summoner: %{last_match: "same_match"}} = :sys.get_state(monitor)
             end) =~ "summoner: fake_name completed match: same_match_uuid"
    end

    test "handle_info(:monitor) _ last match has changed" do
      uuid = Factory.uuid()
      name = Factory.name()
      match_uuid = Factory.uuid()
      different_match_uuid = Factory.uuid()

      {:ok, monitor} =
        SummonerMonitor.start_link(%{
          summoner: %Summoner{
            name: name,
            puuid: uuid,
            last_match: match_uuid
          }
        })

      BlitzElixirProject.MockRiotAPI
      |> expect(:last_completed_match_uuid, fn ^uuid -> different_match_uuid end)

      assert capture_log(fn ->
               Process.send(monitor, :monitor, [])
               assert %{summoner: %{last_match: ^different_match_uuid}} = :sys.get_state(monitor)
             end) =~ "summoner: #{name} completed match: #{different_match_uuid}"
    end

    test "handle_info(:kill) _ allows you to end process" do
      {:ok, monitor} =
        SummonerMonitor.start_link(%{
          summoner: Factory.summoner()
        })

      Process.send(monitor, :kill, [])
      Process.sleep(10)
      refute Process.alive?(monitor)
    end

    test "handle_info(:kill) _ scheduled kill for timeout in ms" do
      {:ok, monitor} =
        SummonerMonitor.start_link(%{
          summoner: Factory.summoner(),
          timeout: 1
        })

      Process.sleep(2)
      refute Process.alive?(monitor)
    end
  end
end
