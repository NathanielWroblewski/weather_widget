class Dashing.Forecast extends Dashing.Widget
 
  constructor: ->
    super
    @skycons = new Skycons
      'color': 'white'
    @skycons.play()

  ready: ->
    # This is fired when the widget is done being rendered
 
  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
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
