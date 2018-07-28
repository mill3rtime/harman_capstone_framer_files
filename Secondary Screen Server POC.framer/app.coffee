# === Secondary Screen Socket Listener Framer Prototype ===
		
# Defining some constants for monitoring the imports of several sketch files, as well as adhering to screen size requirements.
IPAD_HEIGHT = 2224
IPAD_WIDTH = 1668
SKETCH_IMPORT_SCALE = 1

defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

screenWidth = Framer.Device.screen.width
widthScale = defaultWidth / screenWidth

Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight

# === Importing Sketch Files ===

# Import sketch file "bus_only", which has just the pass the bus artboards
bus_sketch = Framer.Importer.load("imported/bus_only@1x", scale: SKETCH_IMPORT_SCALE)

# Import sketch file "SecondScreen-7.20 Grouped" which has all the other artboards
sketch = Framer.Importer.load("imported/SecondScreen-7.20%20Grouped@1x", scale: SKETCH_IMPORT_SCALE)

# Defining the starting background board
mainBoard = sketch.start
mainBoard.x = 0
mainBoard.y = 0

# === runCallback ===
TIMEOUT_DELAY = 500 #ms
runCallback = (screen, time) ->
	# A timeout function which pushes the screen `screen` to the front after TIMEOUT_DELAY * time milliseconds
	callback = -> screen_to_show screen
	setTimeout(callback, TIMEOUT_DELAY * time)

# === Concurrency ===

# Because we consistently listen for sockets, we need to implement some form of concurrency control. Here we opt for the simple binary semaphore to do so, locking access to the screen until an animation is complete.
isLocked = false

# === unlock ===
unlock = () ->
# Reset our concurrency variables and push up the main mph screen.
	isLocked = false
	block = false
	mainBoard.visible = false

# === modifiedUnlock ===
modifiedUnlock = () ->
# Unlock control of the screen without pushing the main mph screen back up. This was used during user testing.
	isLocked = false
	block = false

# === series_to_show ===
series_to_show = (screenList, hangAtEnd=false) ->
# This function runs through a series of artboards defined as screenList and shows them one by one with a delay of TIMEOUT_DELAY milliseconds each
	timenum = 1
	# Check to make sure we have access to the screen to update
	if not isLocked and not block
		isLocked = true
		for screen in screenList
			screen_to_show(screen)
			runCallback(screen, timenum)
			timenum = timenum + 1
		if hangAtEnd
			# For user testing, if we just want to show a blank screen at the end
			setTimeout(modifiedUnlock, timenum * TIMEOUT_DELAY)
		else
			setTimeout(unlock, timenum * TIMEOUT_DELAY)

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

# === Artboard Series ===
	
# For feedback we do not yet have animated, we create a series of artboards to walk through (in a slide show style) upon receiving a specific socket message

LEFT_SERIES = [sketch.start, sketch.lane_static, sketch.lane_left_1, sketch.lane_left_2, sketch.lane_left_3, sketch.start]

RIGHT_SERIES = [sketch.start, sketch.lane_static, sketch.lane_right_1, sketch.lane_right_2, sketch.lane_right_3, sketch.start]

BUS_STATIC_SERIES = [sketch.start, bus_sketch.bus_yes_1]

BUS_CONFIRM_SERIES = [sketch.start, bus_sketch.bus_yes_1, bus_sketch.bus_yes_2, bus_sketch.bus_yes_3, bus_sketch.bus_yes_4, bus_sketch.bus_yes_5, bus_sketch.bus_yes_6, bus_sketch.bus_yes_7, bus_sketch.bus_yes_8, bus_sketch.bus_yes_9, sketch.start]

BUS_DENY_SERIES = [sketch.start, bus_sketch.bus_no_1, bus_sketch.bus_no_2, bus_sketch.bus_no_3, bus_sketch.bus_no_4, bus_sketch.bus_no_5, sketch.start]

BINARY_CONFIRM_SERIES_A = [sketch.start, sketch.binary_confirm_1, sketch.binary_confirm_2, sketch.binary_confirm_3, sketch.binary_confirm_4, sketch.binary_confirm_5, sketch.binary_confirm_6, sketch.binary_confirm_7, sketch.binary_confirm_8, sketch.binary_confirm_9, sketch.start]

BINARY_DENY_SERIES_B = [sketch.start, sketch.binary_deny_1, sketch.binary_deny_2, sketch.binary_deny_3, sketch.binary_deny_4, sketch.binary_deny_5, sketch.start]

# Listen for a websocket event at the server specified at
# the bottom of `index.html`

# === Begin Speed Up/Down Animation ===
{TextLayer, convertTextLayers} = require 'TextLayer'

# Import a new sketch file, the second screen components for animation only
sketch = Framer.Importer.load("imported/Sketch%20Imports%20Second%20Screen@1x", scale: 1)

Framer.Extras.Hints.disable()

Utils.globalLayers(sketch)

speedArray = [sketch.Speed_Text,sketch.MPH, sketch.Speed_Highlight]

Top_Text = sketch.Top_Text.convertToTextLayer()
Bottom_Text = sketch.Bottom_Text.convertToTextLayer()
Speed_Text = sketch.Speed_Text.convertToTextLayer()
MPH = sketch.MPH.convertToTextLayer()

textArray = [Top_Text,Bottom_Text,Speed_Text,MPH]

pulse = sketch.Speed_Highlight

# === Defining Speed Control Constants for Animation ===

# Additional Concurrency Control
done = false
block = false

stringStart = Transition_String.maxY

startSpeed = 36
downSpeed = 24
upSpeed = 48
stringCount = 0
stringTime1 = 2
fillTime1 = 3
speed = null
newSpeed = 0

rangeUp =
	min: startSpeed
	max: upSpeed
	
rangeDown =
	min: downSpeed
	max: startSpeed

# === Defining States for Animation Elements ===
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

Straight_String.onAnimationEnd ->
	block = false
	
# === setDefaultState ===
setDefaultState = () ->
	# Sets the canvas to be our static display showing the current driving speed
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
	centerText()

# === setAccelState ===
setAccelState = () ->
	# Sets the canvas to be either speeding up or slowing down, based on the input change in speed in conjunction with various elements animating
	if speed == "up"
		Top_Text.text = "SPEED: ACCELERATING"
	if speed == "down" 
		Top_Text.text = "SPEED: DECELERATING"
	Bottom_Text.text = "SETTING NEW SPEED"
	centerText()
	Up_String.visible = false
	Fill_Speed.visible = true
	sketch.Speed_Highlight.visible = false
	Straight_String.opacity = 0
	Bottom_Text.animate
		opacity: 1
	Top_Text.animate
		opacity: 1
		
# === stringToAccel ===
stringToAccel = () ->
	# Stretches the white line upward in conjunction with a speeding up event
	Transition_String.visible = true
	Transition_String. opacity = 1
	Transition_String. rotation = 0
	sketch.Transition_String.animate
		scaleY: 4
		minY: 130
		options:
			time: stringTime1
			curve: Bezier.easeIn

# === stringToDecel ===
stringToDecel = () ->
	# Stretches the white line downward in conjunction with a slowing down event
	Transition_String.visible = true
	sketch.Transition_String.opacity = 1
	Transition_String. rotation = 180
	sketch.Transition_String.animate
		scaleY: 4
		minY: Dividing_Bar.y - 220
		options:
			time: stringTime1
			curve: Bezier.easeIn

# === fillToAccel ===
fillToAccel = () ->
	# Stretches the blue fill upwards in conjunction with a speeding up event or downwards in conjunction with a slowing down event
	Fill_Speed.visible = true
	if speed == "down"
		Fill_Speed.y = 0
		Fill_Speed.rotation = 180
		Fill_Speed.animate
			scaleY: 6
			scaleX: 1.15
			y: Transition_String.maxY + 100			
			options: 
				curve: Bezier.easeIn
				time: fillTime1
	else if speed == "up"
		sketch.Fill_Speed.animate
			scaleY: 5.8
			scaleX: 1.15
			maxY: Transition_String.maxY
			y: 200
			options: 
				curve: Bezier.easeIn
				time: fillTime1
				
# === centerText ===
centerText = () ->
	for layer in textArray
		layer.autoSize = true
		layer.centerX()

# === pulseAnimation ===
pulseAnimation = () ->
	# Controlling two pulses of the white circle behind the number after an animation has completed involving it
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
			
# === countUp ===			
countUp = () ->
	# Staggers time before moving the number up one to coordinate with the other animations as speed increases
	time = (stringTime1/(upSpeed - startSpeed))
	for i in [0..(rangeUp.max-rangeUp.min)]
		do (i) ->
			Utils.delay time *i, ->
				newSpeed = startSpeed+i
				Speed_Text.text = newSpeed
				Speed_Text.centerX()

# === countDown ===
countDown = () ->
	# Staggers time before moving the number down one to coordinate with the other animations as speed decreases
	time = (stringTime1/(startSpeed - downSpeed))
	for i in [0..(rangeDown.max-rangeDown.min)]
		do (i) ->
			Utils.delay time*i, ->
				newSpeed = startSpeed-i
				Speed_Text.text = newSpeed
				Speed_Text.centerX()

setDefaultState()
centerText()

# === moveUp ===
moveUp = () ->
	# General chain of animations to run as speed increases
	accel.bringToFront()
	mainBoard.visible = false
	if block == false
		mainBoard.visible = false
		setDefaultState()
		speed = "up"
		setAccelState()
		stringToAccel()
		fillToAccel()
		countUp()
		done = false
		block = true

# === moveDown ===
moveDown = () ->
	# General chain of animations to run as speed decreases
	accel.bringToFront()
	mainBoard.visible = false
	if block == false
		setDefaultState()
		speed = "down"
		setAccelState()
		stringToDecel()
		fillToAccel()
		countDown()
		done = false
		block = true

# === DEBUG Buttons for Animation ===

# For the purposes of mimicing the socket calls we have two invisible buttons mimicing the incoming socket messages to speed up and slow down
button = new Layer
	opacity: 0

button2 = new Layer
	opacity: 0
	y: 305
	x: -31
	
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

# === Animation Ending Events ===
Transition_String.onAnimationEnd ->
	# Set the white string back to a horizontal line
	stringCount += 1
	if stringCount == 2
		setDefaultState()
		stringCount = 0

Fill_Speed.onAnimationEnd ->
	# Set the blue fill back to a full-screen effect
	if !done
		pulseAnimation()
		done = true 
		Utils.delay 3, ->
			Fill_Speed.states.switchInstant "home"
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

# === Socket Listener ===
ws.onmessage = (event) ->
# Run various animations/walkthroughs as different socket messages come through the express server
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

