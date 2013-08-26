Dashing Weather Widget
=
Description
-

A [Dashing](http://shopify.github.com/dashing) widget to display weather information using [World Weather Online](http://www.worldweatheronline.com/) API and [Skycons](http://darkskyapp.github.io/skycons/)

Preview
-
![Screen Shot](/assets/images/screen_shot.png "Screen Shot")

Useage
-
To use this widget, copy `forecast.coffee`, `forecast.html`, and `forecast.scss` into the `/widgets/forecast` directory of your Dashing app.  This directory does not exist in new Dashing apps, so you may have to create it.  Copy the `forecast.rb` file into your `/jobs` folder, and include the Skycons library, `skycons.js`, in your `assets/javascripts` directory.  Edit the `forecast.rb` file to include your World Weather Online API key and your zip code.

To include the widget in a dashboard, add the following to your dashboard layout file:

#####dashboards/sample.erb
    ...
      <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
        <div data-id="forecast" data-view="Forecast" data-title="Weather Forecast" ></div>
      </li>
    ...

Requirements
-
* [World Weather Online](http://www.worldweatheronline.com/) API Key (which you can get [here](http://developer.worldweatheronline.com/member/register))
* [Skycons](http://darkskyapp.github.io/skycons/) library
* Zip code

Code
-

#####widgets/forecast/forecast.coffee

    class Dashing.Forecast extends Dashing.Widget

      constructor: ->
        super
        @skycons = new Skycons
          'color': 'white'
        @skycons.play()

      ready: ->

      onData: (data) ->
        @setSkycon data.code

      setSkycon: (currentCondition) ->
        weatherCodes =
          'Skycons.CLEAR_DAY'        : ['113']
          'Skycons.PARTLY_CLOUDY_DAY': ['116']
          'Skycons.CLOUDY'           : ['119','122','200']
          'Skycons.FOG'              : ['143','248','260']
          'Skycons.RAIN'             : ['176','185','182'
                                        '263','266','281'
                                        '284','293','296'
                                        '299','302','305'
                                        '308','311','314'
                                        '317','320','350'
                                        '353','356','359'
                                        '362','365','374'
                                        '377','386','389']
          'Skycons.SNOW'             : ['179','227','230'
                                        '323','326','329'
                                        '332','335','338'
                                        '368','371','392'
                                        '395']
        for skycon, codes of weatherCodes when currentCondition in codes
          @skycons.set 'weather-icon', eval(skycon)



#####widgets/forecast/forecast.html

    <h1 class="title" data-bind="title"></h1>
    <canvas id="weather-icon" width="75px" height="75px"></canvas>
    <h3 class="farenheit" data-bind="farenheit | raw"></h3>
    <p class="summary" data-bind="summary | raw"></p>
    <p class="more-info">Powered by World Weather Online</p>
    <p class="updated-at" data-bind="updatedAtMessage"></p>


#####widgets/forecast/forecast.scss

    $background-color:  #EC3C6B;
    $full-color:  rgba(255, 255, 255, 1);
    $light-color: rgba(255, 255, 255, 0.7);

    .widget-forecast {
      background-color: $background-color;
      .title {
        color: $light-color;
      }
      .temp {
        color: $full-color;
      }
      .summary {
        color: $light-color;
      }
      .more-info {
        color: $light-color;
      }
      .updated-at {
        color: rgba(0, 0, 0, 0.3);
      }
    }


#####jobs/forecast.rb

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

