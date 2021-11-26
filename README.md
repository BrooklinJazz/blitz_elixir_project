# BlitzElixirProject
Create a mix project application that:

- Given a valid summoner_name and region will fetch all summoners this summoner has
played with in the last 5 matches. This data is returned to the caller as a list of
summoner names (see below). Also, the following occurs:
  - Once fetched, all summoners will be monitored for new matches every minute
  for the next hour
  - When a summoner plays a new match, the match id is logged to the console, such as: Summoner <summoner name> completed match <match id> The returned data should be formatted as: [summoner_name_1, summoner_name_2, ...]

Please upload this project to Github and send us the link.

Notes:
- Make use of Riot Developer API
  - https://developer.riotgames.com/apis
  - https://developer.riotgames.com/apis#summoner-v4
  - https://developer.riotgames.com/apis#match-v5


You will have to generate an api key. Please make this configurable so we can
substitute our own key in order to test.

## Getting Started.
- See the .env_template file. Please use the .env_template file to create your own .env file and replace the RIOT_API_KEY value with your own.
- ensure that you have loaded the .env file by running source .env in your terminal
- run the project with the IEx shell.
```
iex -S mix
```
- run the main monitoring function with a valid summoner_name and region.

```elixir
BlitzElixirProject.Main.find_and_monitor_competitors("Sn1per1", "na1")
```

- You should see a list of competitors. This function is fairly slow, mostly due to throttling to avoid hitting API limits.
```elixir
# i.e.
["Lan Tank", "HypnoChinchilla", "HypnoYoshi", "HypnoDrake", "Raiquiri", "Taco",
 "D SHAO", "pretty egirl", "Sn1per1", "heidy", "TFBlade4", "Keel7", "APA1",
 "stray kid", "Latence", "Löve miemie baby", "b sMooTh x ", "Asyc",
 "Ryu Min seok", "Revenge", "dvni", "Tentakai", "Choco Express", "Chicktapus",
 "Shang Dan", "Le Meep Meep", "         Mıü Mıü", "Captain Yuubee",
 "Sakura PaiPai", "OUT Man ", "WWXXTT", "Doinþ", "tiaotiao tang SK", "Moke",
 "Bíg T", "Cigafiy", "Nightsaw9", "Tiny Asian Boy", "Malstixy", "Beniona",
 "MySwordCrimson", "AIDENNNN", "KryRa", "YNO BLITZ"]
```

- ever minute, you will be notified if a summoner completes a game.

```
01:26:25.243 [info] summoner: Taco completed match: NA1_4115154238
```