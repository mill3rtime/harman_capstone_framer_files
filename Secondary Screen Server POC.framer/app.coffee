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
	block = false
# 	mainBoard.visible = false

modifiedUnlock = () ->
	isLocked = false
	block = false
	
series_to_show = (screenList, hangAtEnd=false) ->
	timenum = 1
	if not isLocked and not block
		isLocked = true
		for screen in screenList
			screen_to_show(screen)
			runCallback(screen, timenum)
			timenum = timenum + 1
		if hangAtEnd
			setTimeout(modifiedUnlock, timenum * TIMEOUT_DELAY)
		else
			setTimeout(unlock, timenum * TIMEOUT_DELAY)
# 		setTimeout(setDefaultState, timenum * TIMEOUT_DELAY)
# 		sleep(150)
# Generic helper function that brings the desired layer to
# the forefront 
screen_to_show = (screen) ->
	if screen
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

#SETUP
# Import file "Sketch Imports Second Screen"
{TextLayer, convertTextLayers} = require 'TextLayer'

sketch = Framer.Importer.load("imported/Sketch%20Imports%20Second%20Screen@1x", scale: 1)

Framer.Extras.Hints.disable()


SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536

button = new Layer
	opacity: 0

button2 = new Layer
	opacity: 0
	y: 305
	x: -31

	
Utils.globalLayers(sketch)

speedArray = [sketch.Speed_Text,sketch.MPH, sketch.Speed_Highlight]

defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

screenWidth = Framer.Device.screen.width
widthScale = defaultWidth / screenWidth

#TODO JS: 
Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight
	
///TODO///
# remove magic numbers and create system for tracking y to match two animations

Top_Text = sketch.Top_Text.convertToTextLayer()
Bottom_Text = sketch.Bottom_Text.convertToTextLayer()
Speed_Text = sketch.Speed_Text.convertToTextLayer()


pulse = sketch.Speed_Highlight
# Straight_String.animationOptions = {time: .4, curve: Bezier.ease}
# 
# Top_Text.animationOptions = {time: 3, curve: Bezier.ease}
# Bottom_Text.animationOptions = {time: 3, curve: Bezier.ease}
done = false
block = false

stringStart = Transition_String.maxY

startSpeed = 36
downSpeed = 24
upSpeed = 48
stringCount = 0

///COUNTING VARIABLES///

newSpeed = 0

rangeUp =
	min: startSpeed
	max: upSpeed
	
rangeDown =
	min: downSpeed
	max: startSpeed
	
stringTime1 = 3
fillTime1 = 6
speed = null	
	
///Variables///	
# reinit = () ->
# 	Top_Text = sketch.Top_Text.convertToTextLayer()
# 	Bottom_Text = sketch.Bottom_Text.convertToTextLayer()
# 	Speed_Text = sketch.Speed_Text.convertToTextLayer()
# 	
# 	
# 	pulse = sketch.Speed_Highlight
# 	# Straight_String.animationOptions = {time: .4, curve: Bezier.ease}
# 	# 
# 	# Top_Text.animationOptions = {time: 3, curve: Bezier.ease}
# 	# Bottom_Text.animationOptions = {time: 3, curve: Bezier.ease}
# 	done = false
# 	block = false
# 	
# 	stringStart = Transition_String.maxY
# 	
# 	startSpeed = 36
# 	downSpeed = 24
# 	upSpeed = 48
# 	stringCount = 0
# 	
# 	///COUNTING VARIABLES///
# 	
# 	newSpeed = 0
# 	
# 	rangeUp =
# 		min: startSpeed
# 		max: upSpeed
# 		
# 	rangeDown =
# 		min: downSpeed
# 		max: startSpeed
# 		
# 	stringTime1 = 3
# 	fillTime1 = 6
# 	speed = null
# 		
# 	///STATES///
# setDefaultState()
		
///Functions///
sketch.Speed_Highlight.states =
	big:
		scale: 1.5
	reg:
		scale: 1
sketch.Speed_Highlight.animationOptions = 
	curve: Bezier.linear
	time: .4
delete sketch.Speed_Highlight.states.default


Fill_Speed.states =
	home:
		width: 1668
		height: 82
		scaleY: 1
		scaleX: 1
		visible: false
		x: 0
		y: 718

Transition_String.states =
	home:
		width: 1668
		height: 84
		scaleY: 1
		scaleX: 1
		visible: false
		x: 0
		y: 318		
		
setDefaultState = () ->
	Top_Text.text = "SELF DRIVING: ON"
	Bottom_Text.text = "CURRENT SPEED"
	Bottom_Text.opacity = 1
	Bottom_Text.visible = true
	Up_String.visible = false
	Transition_String.opacity = 0
	Speed_Text.text = startSpeed
	done = true
	Fill_Speed.visible = false
	Straight_String.animate
		opacity: 1

setAccelState = () ->
	if speed == "up"
		Top_Text.text = "SPEED: ACCELERATING"
	if speed == "down" 
		Top_Text.text = "SPEED: DECELERATING"
	Bottom_Text.text = "SETTING NEW SPEED"
	Up_String.visible = false
	Fill_Speed.visible = true
	sketch.Speed_Highlight.visible = false
	Straight_String.opacity = 0
	Bottom_Text.animate
		opacity: 1
	Top_Text.animate
		opacity: 1
#String to Accel Decel
stringToAccel = () ->
	Transition_String.visible = true
	Transition_String. opacity = 1
	Transition_String. rotation = 0
	sketch.Transition_String.animate
		scaleY: 4
		minY: 130
		options:
			time: stringTime1
			curve: Bezier.easeIn

stringToDecel = () ->
	Transition_String.visible = true
	sketch.Transition_String.opacity = 1
	Transition_String. rotation = 180
	sketch.Transition_String.animate
		scaleY: 4
		minY: Dividing_Bar.y - 220
		options:
			time: stringTime1
			curve: Bezier.easeIn

#Also decel fill
fillToAccel = () ->
	if speed == "down"
		Fill_Speed.y = 0
		Fill_Speed.rotation = 180
	Fill_Speed.visible = true
	if speed == "down"
# 		print "down"
		Fill_Speed.animate
			scaleY: 6
			scaleX: 1.15
			y: Transition_String.maxY + 100			
			options: 
				curve: Bezier.easeIn
				time: fillTime1
				
	if speed == "up"
		sketch.Fill_Speed.animate
			scaleY: 5.8
			scaleX: 1.15
			maxY: Transition_String.maxY
			y: 200
			options: 
				curve: Bezier.easeIn
				time: fillTime1
			
pulseAnimation = () ->
	pulse.visible = true
	pulse.stateCycle "big"
	pulse.onAnimationEnd ->
		pulse.off Events.AnimationEnd
		pulse.stateCycle "reg"
		pulse.onAnimationEnd ->
			pulse.off Events.AnimationEnd
			pulse.stateCycle "big"
			pulse.onAnimationEnd ->
				pulse.off Events.AnimationEnd
				pulse.stateCycle "reg"
			
///COUNTING FUNCTIONS///			

newSpeed = 0

countUp = () ->
	time = (stringTime1/(upSpeed - startSpeed))
# 	print time
	for i in [0..(rangeUp.max-rangeUp.min)]
		do (i) ->
			Utils.delay time *i, ->
				newSpeed = startSpeed+i
				Speed_Text.text = newSpeed

countDown = () ->
	time = (stringTime1/(startSpeed - downSpeed))
	for i in [0..(rangeDown.max-rangeDown.min)]
		do (i) ->
			Utils.delay time*i, ->
				newSpeed = startSpeed-i
				Speed_Text.text = newSpeed
# 	print "go"				
			

///UI///
setDefaultState()
sketch.MPH.x = 160

moveUp = () ->
	accel.bringToFront()
	mainBoard.visible = false
	if block == false
# 		reinit()
		mainBoard.visible = false
# 		accel.bringToFront()
		setDefaultState()
		speed = "up"
		setAccelState()
		stringToAccel()
		fillToAccel()
		countUp()
		done = false
# 		print 'block true'
		block = true

moveDown = () ->
	accel.bringToFront()
	mainBoard.visible = false
	if block == false
# 		reinit()
		setDefaultState()
		speed = "down"
		setAccelState()
		stringToDecel()
		fillToAccel()
		countDown()
		done = false
		block = true

button.onClick ->
	if block == false
		speed = "up"
		setAccelState()
		stringToAccel()
		fillToAccel()
		countUp()
		done = false
		block = true

button2.onClick ->
	if block == false
		speed = "down"
		setAccelState()
		stringToDecel()
		fillToAccel()
		countDown()
		done = false
		block = true



Transition_String.onAnimationEnd ->
	stringCount += 1
	if stringCount == 2
		setDefaultState()
		stringCount = 0
# 		print 'block false'
		block = false

	
		

Fill_Speed.onAnimationEnd ->
	if !done
		pulseAnimation()
		done = true 
		Utils.delay 3, ->
			Fill_Speed.states.switchInstant "home"
		# 	Fill_Speed.off(Events.AnimationEnd)
			Transition_String.states.switch "home"
			
			startSpeed = newSpeed
			upSpeed = startSpeed + 12
			downSpeed = startSpeed - 12
			
			if startSpeed < 10
				startSpeed = 30

			if speed = "down"
				Fill_Speed.rotation = 180

			if speed = "up"
				Fill_Speed.rotation = 0
		
					
	



# Transition_String.on "change:y", ->
# # 	Speed_Text.text = (Utils.round(Transition_String.y))
# 	for i in [0..(range.max-range.min)]
# 	do (i) ->
# 		Utils.delay time*i, ->
# 			text.html = range.min+i
# 	

# if Fill_Speed.y >= Transition_String.y
# 	Transition_String.y =
		


ws.onmessage = (event) ->
 switch event.data
   when 'speed_up' then moveUp()
   when 'slow_down' then moveDown()
   when 'left' then series_to_show(LEFT_SERIES)
   when 'right' then series_to_show(RIGHT_SERIES)
   when 'turn_right' then series_to_show(BINARY_CONFIRM_SERIES_A)
   when 'no_turn_right' then series_to_show(BINARY_DENY_SERIES_B)
   when 'no_pass_bus' then series_to_show(BUS_DENY_SERIES)
   when 'pass_bus' then series_to_show(BUS_CONFIRM_SERIES)
   when 'static_bus' then series_to_show(BUS_STATIC_SERIES, hangAtEnd=true)
   else screen_to_show(sketch.start)

