defmodule BlitzElixirProject.RegionConverter do
  def to_region(routing_value) do
    cond do
      Regex.match?(~r/na|br|la|las|oce/, routing_value) -> "americas"
      Regex.match?(~r/kr|jp/, routing_value) -> "asia"
      Regex.match?(~r/reune|euw|tr|ru/, routing_value) -> "europe"
      true -> {:error, :invalid_routing_value}
    end
  end
end
