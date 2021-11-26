ExUnit.start(exclude: :prod)
Mox.defmock(BlitzElixirProject.MockRiotAPI, for: BlitzElixirProject.RiotAPI)
Application.put_env(:blitz_elixir_project, :riot_api, BlitzElixirProject.MockRiotAPI)
