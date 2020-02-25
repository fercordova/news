require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
require "date"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     
ForecastIO.api_key = "ed845b219a6a80bf299ff94d06d8879a"
news = HTTParty.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=f2e666c442e549f18078ea344ab525c7").parsed_response.to_hash

get "/" do
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates
    @forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]
    @forecast_temperature = Array.new
    @forecast_summary = Array.new
           y = 0
    for day in @forecast["daily"]["data"] do
    @forecast_temperature[y] = day["temperatureHigh"]
    @forecast_summary[y] = day["summary"]
        y = y+1
    end
    @titulos=Array.new
    @historia=Array.new
    x = 0
    for story in news["articles"] do
    @titulos[x]=story["title"]
    @historia[x]=story["url"]
        x = x+1
    end
      view "news"
end
