# Generic helper function that brings the desired layer to
# the forefront 
screen_to_show = (screen) ->
	screen.x = 0
	screen.bringToFront()
	
# Listen for a websocket event at the server specified at
# the bottom of index.html 
ws.onmessage = (event) ->
 switch event.data
   when 'speed_up' then screen_to_show(speed_up)
   when 'slow_down' then screen_to_show(slow_down)
   else screen_to_show(idle)

