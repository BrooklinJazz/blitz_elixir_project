defmodule BlitzElixirProject do
  @moduledoc """
  Documentation for `BlitzElixirProject`.
  """
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor,
       strategy: :one_for_one, name: BlitzElixirProject.SummonerMonitorSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
