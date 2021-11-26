defmodule BlitzElixirProject.Factory do
  alias BlitzElixirProject.Summoner

  def uuid do
    Faker.UUID.v4()
  end

  def name do
    Faker.Superhero.name()
  end

  def summoner do
    %Summoner{
      name: name(),
      puuid: uuid(),
      last_match: uuid()
    }
  end
end
