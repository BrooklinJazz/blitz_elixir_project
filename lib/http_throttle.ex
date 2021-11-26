defmodule BlitzElixirProject.HTTPThrottle do
  require Logger

  def get(url, params \\ []) do
    Process.sleep(100)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(URI.encode(url), [], params: [api_key: api_key()] ++ params),
         {:ok, response} <- JSON.decode(body) do
      {:ok, response}
    else
      _ ->
        {:error, :unhandled}
    end
  end

  defp api_key do
    Application.fetch_env!(:blitz_elixir_project, :riot_api_key)
  end
end
