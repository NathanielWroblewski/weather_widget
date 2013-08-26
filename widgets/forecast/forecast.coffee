class Dashing.Forecast extends Dashing.Widget
 
  constructor: ->
    super
    @skycons = new Skycons
      'color': 'white'
    @skycons.play()

  ready: (data) ->
    # This is fired when the widget is done being rendered
 
  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    @setSkycon(data.code)

  setSkycon: (code) ->
    if code is '113'
      skycon = eval 'Skycons.CLEAR_DAY'
      @skycons.set('weather-icon', skycon) if skycon
    else if code is '116'
      skycon = eval 'Skycons.PARTLY_CLOUDY_DAY'
      @skycons.set('weather-icon', skycon) if skycon
    else if code in ['119','122','200']
      skycon = eval 'Skycons.CLOUDY'
      @skycons.set('weather-icon', skycon) if skycon
    else if code in ['143','248','260']
      skycon = eval 'Skycons.FOG'
      @skycons.set('weather-icon', skycon) if skycon
    else if code in ['176','185','182','263','266','281', '284','293','296','299','302','305','308','311','314','317','320','350','353','356','359','362','365','374','377','386','389']
      skycon = eval 'Skycons.RAIN'
      @skycons.set('weather-icon', skycon) if skycon
    else if code in ['179','227','230','323','326','329','332','335','338','368','371','392','395']
      skycon = eval 'Skycons.SNOW'
      @skycons.set('weather-icon', skycon) if skycon
