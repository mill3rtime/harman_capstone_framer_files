
# === SETUP ===
		
# Defining some constants for monitoring the imports of several sketch files, as well as adhering to screen size requirements.
IPAD_HEIGHT = 2224
IPAD_WIDTH = 1668
SKETCH_IMPORT_SCALE = 1

Screen.backgroundColor = "#000"

defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

screenWidth = Framer.Device.screen.width
widthScale = defaultWidth / screenWidth

Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight

Framer.Device.background.backgroundColor = "#000"

# === Importing Sketch Files ===

sketch = Framer.Importer.load("imported/Sketch%20Imports%20Second%20Screen@1x", scale: 1)


# === Begin Speed Up/Down Animation ===
{TextLayer, convertTextLayers} = require 'TextLayer'

# Import a new sketch file, the second screen components for animation only

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
	Transition_String.rotation = 180
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

# button = new Layer
# 	opacity: 0
# 
# button2 = new Layer
# 	opacity: 0
# 	y: 305
# 	x: -31
# 	
Speed_Up.onClick ->
	if block == false
		speed = "up"
		setAccelState()
		stringToAccel()
		fillToAccel()
		countUp()
		done = false
		block = true

Slow_Down.onClick ->
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

