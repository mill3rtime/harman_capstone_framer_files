# Import file "bus_only"
bus_sketch = Framer.Importer.load("imported/bus_only@1x", scale: 1)
# Import file "SecondScreen-7.20 Grouped"
sketch = Framer.Importer.load("imported/SecondScreen-7.20%20Grouped@1x", scale: 1)

# Import file "SecondScreen-7.20"
# sketch = Framer.Importer.load("imported/SecondScreen-7.20@1x", scale: 1)

# Utils.globalLayers(sketch)

IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536
SKETCH_IMPORT_SCALE = 1.1

defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

screenWidth = Framer.Device.screen.width
widthScale = defaultWidth / screenWidth

#TODO JS: 
Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight

mainBoard = sketch.start

# to make other artboards visible make xy = 0 and current board not visible.
mainBoard.x = 0
mainBoard.y = 0

canvas = new Layer
	width: Screen.width
	height: Screen.height
	opacity: 0
	
sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

TIMEOUT_DELAY = 500 #ms
runCallback = (screen, time) ->
	callback = -> screen_to_show screen
	setTimeout(callback, TIMEOUT_DELAY * time)

# Woo concurrency in timeouts
isLocked = false
unlock = () ->
	isLocked = false
	
series_to_show = (screenList) ->
	timenum = 1
	if not isLocked
		isLocked = true
		for screen in screenList
			screen_to_show(screen)
			runCallback(screen, timenum)
			timenum = timenum + 1
		setTimeout(unlock, timenum * TIMEOUT_DELAY)
# 		sleep(150)
# Generic helper function that brings the desired layer to
# the forefront 
screen_to_show = (screen) ->
	screen.x = 0
	screen.y = 0
	mainBoard.visible = false
	screen.visible = true
	mainBoard = screen
	screen.bringToFront()

ACCEL_SERIES = [sketch.start, sketch.accel_1, sketch.accel_2, sketch.accel_3, sketch.accel_4, sketch.accel_5, sketch.accel_6, sketch.start]

DECEL_SERIES = [sketch.start, sketch.decel_1, sketch.decel_2, sketch.decel_3, sketch.decel_4, sketch.decel_5, sketch.decel_6, sketch.start]

LEFT_SERIES = [sketch.start, sketch.lane_static, sketch.lane_left_1, sketch.lane_left_2, sketch.lane_left_3, sketch.start]

RIGHT_SERIES = [sketch.start, sketch.lane_static, sketch.lane_right_1, sketch.lane_right_2, sketch.lane_right_3, sketch.start]

BUS_STATIC_SERIES = [sketch.start, bus_sketch.bus_yes_1]

BUS_CONFIRM_SERIES = [sketch.start, bus_sketch.bus_yes_1, bus_sketch.bus_yes_2, bus_sketch.bus_yes_3, bus_sketch.bus_yes_4, bus_sketch.bus_yes_5, bus_sketch.bus_yes_6, bus_sketch.bus_yes_7, bus_sketch.bus_yes_8, bus_sketch.bus_yes_9, sketch.start]

BUS_DENY_SERIES = [sketch.start, bus_sketch.bus_no_1, bus_sketch.bus_no_2, bus_sketch.bus_no_3, bus_sketch.bus_no_4, bus_sketch.bus_no_5, sketch.start]

BINARY_CONFIRM_SERIES_A = [sketch.start, sketch.binary_confirm_1, sketch.binary_confirm_2, sketch.binary_confirm_3, sketch.binary_confirm_4, sketch.binary_confirm_5, sketch.binary_confirm_6, sketch.binary_confirm_7, sketch.binary_confirm_8, sketch.binary_confirm_9, sketch.start]

BINARY_DENY_SERIES_B = [sketch.start, sketch.binary_deny_1, sketch.binary_deny_2, sketch.binary_deny_3, sketch.binary_deny_4, sketch.binary_deny_5, sketch.start]
# Listen for a websocket event at the server specified at
# the bottom of index.html 
ws.onmessage = (event) ->
 switch event.data
   when 'speed_up' then series_to_show(ACCEL_SERIES)
   when 'slow_down' then series_to_show(DECEL_SERIES)
   when 'left' then series_to_show(LEFT_SERIES)
   when 'right' then series_to_show(RIGHT_SERIES)
   when 'turn_right' then series_to_show(BINARY_CONFIRM_SERIES_A)
   when 'no_turn_right' then series_to_show(BINARY_DENY_SERIES_B)
   when 'no_pass_bus' then series_to_show(BUS_DENY_SERIES)
   when 'pass_bus' then series_to_show(BUS_CONFIRM_SERIES)
   when 'static_bus' then series_to_show(BUS_STATIC_SERIES)
   else screen_to_show(sketch.start)

