defmodule BlitzElixirProject.SummonerMonitorSupervisorTest do
  use ExUnit.Case
  alias BlitzElixirProject.Factory
  alias BlitzElixirProject.SummonerMonitor
  alias BlitzElixirProject.SummonerMonitorSupervisor

  describe "MonitorSupervisor" do
    test "start_child" do
      {:ok, supervisor} = SummonerMonitorSupervisor.start_link()

      assert {:ok, _monitor} =
               DynamicSupervisor.start_child(
                 supervisor,
                 {SummonerMonitor, %{summoner: Factory.summoner()}}
               )
    end

    test "allow one monitor per summoner" do
      {:ok, supervisor} = SummonerMonitorSupervisor.start_link()
      summoner = Factory.summoner()

      {:ok, monitor1} =
        DynamicSupervisor.start_child(
          supervisor,
          {SummonerMonitor, %{summoner: summoner}}
        )

      {:error, {:already_started, monitor2}} =
        DynamicSupervisor.start_child(
          supervisor,
          {SummonerMonitor, %{summoner: summoner}}
        )

      assert monitor1 === monitor2
    end
  end
end
