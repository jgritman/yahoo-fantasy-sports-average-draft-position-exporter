# Yahoo Fantasy Sports Average Draft Position Exporter

----

This is a simple Ruby script to export the average draft positions data of players for Yahoo Fantasy Sports games into a csv file.  This data can then be used to help identify undervalued players before the draft or to help tweak a drafting strategy. This program is compatible with any Yahoo Fantasy Sports game via the [Yahoo Fantasy Sports API][http://developer.yahoo.com/fantasysports/].

To run the program, setup the config.yml file as described below, then run

``` console
$ ruby draftresults.rb

The results will show up in a `yahoo-adp.csv` file.

Configuration
------------

To start you'll need a developer API key from Yahoo.  You can request one [here][https://developer.apps.yahoo.com/dashboard/createKey.html].

Copy the `config.yml.sample` to `config.yml` then set the `oauth_key` and `oauth_secret` properties with the values in your requested API.

You'll also need to look up the game id from Yahoo corresponding the game and year you're looking for.  A table of ids can be found [here][http://developer.yahoo.com/fantasysports/guide/game-resource.html#game-resource-desc]

Once you have the game id, set it as the `game_id` property in `config.yml`.