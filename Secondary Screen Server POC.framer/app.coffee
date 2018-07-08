screen_to_show = (screen) ->
	screen.x = 0
	screen.bringToFront()
	
ws.onmessage = (event) ->
 switch event.data
   when 'speed_up' then screen_to_show(speed_up)
   when 'slow_down' then screen_to_show(slow_down)
   else screen_to_show(idle)

