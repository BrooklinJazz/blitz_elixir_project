defmodule BlitzElixirProject.RegionConverterTest do
  use ExUnit.Case
  alias BlitzElixirProject.RegionConverter

  test "to_region" do
    RegionConverter.to_region("na1") === "americas"
  end
end
