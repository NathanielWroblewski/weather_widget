require 'net/http'
require 'uri'
require 'json'

SCHEDULER.every '5m', :first_in => 0 do |job|
  world_weather_online_api_key = '' # your api key here
  zip_code = "94105"                # your zip code here

  uri = URI.parse(
  	'http://api.worldweatheronline.com/free/v1/weather.ashx' +
  	"?key=#{world_weather_online_api_key}&q=#{zip_code}" +
  	'&format=json'
  )

  response    = Net::HTTP.get(uri)
  forecast    = JSON.parse(response)['data']['current_condition'][0]
  description = forecast['weatherDesc'][0]['value']
  farenheit   = forecast['temp_F']
  code        = forecast['weatherCode']

  send_event('forecast', {
  	farenheit: "#{farenheit}&deg;F",
  	summary:   "#{description}",
  	code:      "#{code}"
  })
end
