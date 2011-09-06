require "#{File.dirname(__FILE__)}/oauth_util.rb"
require 'net/http'
require 'rexml/document'
require 'yaml'

CONFIG = YAML::load_file ('config.yml')

o = OauthUtil.new

o.consumer_key = CONFIG['oauth_key']
o.consumer_secret = CONFIG['oauth_secret']

players = []

#the api only returns 25 players at a time, so request up to 1000 players
40.times do |i|
  start = i * 25
  url = "http://fantasysports.yahooapis.com/fantasy/v2/game/#{CONFIG['game_id']}/players;start=#{start}/draft_analysis";
  parsed_url = URI.parse( url )

  Net::HTTP.start( parsed_url.host ) do | http |
    req = Net::HTTP::Get.new "#{ parsed_url.path }?#{ o.sign(parsed_url).query_string }"
    response = http.request(req)
    doc = REXML::Document.new response.read_body
    doc.elements.each('fantasy_content/game/players/player') do |ele|
       players << {
         :first_name => ele.elements["name"].elements["ascii_first"].text,
         :last_name => ele.elements["name"].elements["ascii_last"].text,
         :team => ele.elements['editorial_team_abbr'].text,
         :adp =>  ele.elements["draft_analysis"].elements["average_pick"].text,
         :drafted_pct => ele.elements["draft_analysis"].elements["percent_drafted"].text
       }
    end
  end
end

# discard any players drafted in less than 2% of leagues
players = players.select { |x| x[:drafted_pct].to_f >= 0.02}

# sort players by 'adjusted' adp to peanilize players not widely drafted
def adjusted_adp(player)
  (100 - (player[:drafted_pct].to_f * 100)) + player[:adp].to_f
end

players.sort! {|x,y| adjusted_adp(x) <=> adjusted_adp(y)}

outfile = File.open("yahoo-adp.csv",'w')
players.each do |player| 
 outfile.puts "#{player[:first_name]} #{player[:last_name]},#{player[:team]},#{player[:adp]},#{player[:drafted_pct]}"
end
outfile.close