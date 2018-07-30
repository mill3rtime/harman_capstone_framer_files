# # Speed/Lane Positioning Control
# This file outlines the generic speed and lane positioning control for controlling continuous aspects of an Autonomous Vehicle.

# # Note
# This file contains two interfaces. The second is out of date and irrelevant, however that code is still present in this file. To transition between the interfaces, use the button `switchScreenButton` all the way in the top right (hidden).

{Pointer} = require "Pointer"
#disable purple hints
Framer.Extras.Hints.disable()


# Import the CARLA API and begin the server
CARLA_API = require "CARLA_API"
CARLA_API.begin_server()


# Import file "Interactions_ORIGINAL"
SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536
sketch = Framer.Importer.load("imported/Interactions_ORIGINAL@1x", scale: SKETCH_IMPORT_SCALE)

Utils.globalLayers(sketch)

# Define the width and height scaled up based on our resolution and import scaling. With a projector this can be removed.
defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight

circles = sketch.circles_offset
mainBoard = sketch.Version_One_Default

# to make other artboards visible make xy = 0 and current board not visible.
mainBoard.x = 0
mainBoard.y = 0

canvas = new Layer
	width: Screen.width
	height: Screen.height
	opacity: 0

# Variables to keep track of our tapping events
tapX = 0
tapY = 0


# Global Variables
speedUpSwitch = false
switchScreenCounter = 4
trailSwitch = false
currentScreen = "v1"
trackingOffset = 300
bumperTapped = null
initialY = 0
initialX = 0
y2 = 0
x2 = 0
# Bumpers refer to the first interface, it is outdated
bumpers = [bottom_bumper,top_bumper,left_bumper,right_bumper]
sideBumpers = [right_bumper,left_bumper, Position1]
vertical_bumpers = [top_bumper, bottom_bumper, Speed3]
stretchY = 0
stretchX = 0

# Variables to detect what section of the interface the user is in.
isLane = false
isSpeed = true
laneDetect  = new Layer
	width: Screen.width
	y: Screen.height - 800
	height: 800
	opacity: 0
speedDetect = new Layer
	width: Screen.width
	height: (Screen.height - laneDetect.height)
	opacity: 0

startYTop = top_bumper.y
startYBottom = bottom_bumper.y

released = true

Speed3.states =
	big:
		scale: 1.5
		animationOptions:
			curve: "spring"
	default:
		scale: 1
		
Position1.states =
	big:
		scale: 1.2
		animationOptions:
			curve: "spring"
	default:
		scale: 1
	

# Button to toggle between the two interfaces
switchScreenButton = new Layer
	visible: false
	width: 316
	height: 294
	
# === trackTaps ===
trackTaps = (touchEvent, layer) ->
	# This function tracks where a user has tapped or click, accountign for a mobile device if need be
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = touchEvent.clientY - layer.y
	else 
		tapX = (touchEvent.offsetX)
		tapY = (touchEvent.offsetY)
# trail design in code
trail = new Layer
	backgroundColor: "rgba(34,167,207,1)"
	y: 0
	x: 0
	blur: 50
	borderRadius: 100
	height: 160
	width: 120
	opacity: 0.3
	visible: false

# === wasTapIn ===
wasTapIn = (shape) ->
	#takes a shape and returns t/f if click is inside of it (using tapY, tapX)
	if (tapY >= shape.minY & tapY <= shape.maxY + 200) && (tapX >= shape.minX &
	tapX <= shape.maxX)
		return true

# === whichBumper ===
whichBumper = () ->
	# Determines which of the bumpers in the bumper interface the user clicked into
	if wasTapIn(bottom_bumper)
		bumperTapped = bottom_bumper
	else if wasTapIn(top_bumper)
		bumperTapped = top_bumper
	else if wasTapIn(right_bumper)
		bumperTapped = right_bumper 
	else if wasTapIn(left_bumper)
		bumperTapped = left_bumper
	else bumperTapped = ""
	
#snailSetup()  
# sets up layers to be dragged around
snailSetup = (shape)->
	shape.x = -500
	shape.y = -500
	shape.visible = false
	shape.draggable = true
	shape.draggable.constraints = {
		width: Screen.width
		height: Screen.height
	}
	shape.draggable.momentum = false
	shape.bounce = false
	shape.draggable.overdrag = false
	

# === bumperStretch ===
bumperStretch = (bumperTapped) ->
	# If the user is dragging from the bottom, speed up
	if bumperTapped == bottom_bumper
		dist =  initialY - stretchY
		bottom_bumper.animate
			scaleY: 1 + (dist/80)
			scaleX: 1 + dist/320
			options:
				time: .1
		top_bumper.off(Events.AnimationStart)
		top_bumper.off(Events.AnimationStop)
		bottom_bumper.onAnimationStart ->
			top_bumper.animate
				y: top_bumper.y - (dist * 3) 
		bottom_bumper.onAnimationEnd -> 
			if released
				top_bumper.animate
					y: startYTop
					options:
						time: .4
						curve: Bezier.ease
	# If the user is dragging from the top, slow down
	if bumperTapped == top_bumper
		dist = stretchY - initialY
		top_bumper.animate
			scaleY: 1 + dist/80
			scaleX: 1 + dist/320
			options:
				time: .1
		bottom_bumper.off(Events.AnimationStart)
		bottom_bumper.off(Events.AnimationStop)
		top_bumper.onAnimationStart ->
			# Start Speeding Up
			bottom_bumper.animate
				y: bottom_bumper.y + (dist * 3)
		top_bumper.onAnimationEnd ->
			if released
				bottom_bumper.animate
					y: startYBottom
					options:
						time: .4
						curve: Bezier.ease
	# If the user is dragging from the left, move to the right
	if bumperTapped == left_bumper
		dist = stretchX - initialX
		left_bumper.animate
			scaleX: 1 + dist/80
			scaleY: 1 + dist/240
			options:
				time: .1
	# If the user is dragging from the right, move to the left
	if bumperTapped == right_bumper
		dist = initialX - stretchX
		right_bumper.animate
			scaleX: 1 + dist/80
			scaleY: 1 + dist/240
			opacity: 1
			options:
				time: .1


# === checkScreenSwitch ===
checkScreenSwitch = () ->
	# See if the user is trying to switch to the bumper interface and let them do so after four clicks (to prevent false positives)
	if wasTapIn(switchScreenButton)
		switchScreenCounter++
	if switchScreenCounter >= 4
		switchScreenCounter = 0
		if currentScreen == "v2"
			sketch.Version2.visible.x = 0
			sketch.Version2.visible.y = 0
			sketch.Version2.visible = false
			sketch.Version_One_Default.visible = true
			circles.parent = sketch.Version_One_Default
			currentScreen = "v1"
		
		else if currentScreen == "v1"
			sketch.Version2.x = 0
			sketch.Version2.y = 0
			sketch.Version_One_Default.visible = false
			sketch.Version2.visible = true
			circles.parent = sketch.Version2
			currentScreen = "v2"

# === moveToTap ===
moveToTap = (visual) ->
	# Generic function that moves the visual element `visual` to where the user tapped or dragged to
	visual.x = tapX - trackingOffset
	visual.y = tapY - trackingOffset

# === returnBumpers ===
returnBumpers = (layer) ->
	# Takes a bumper on the bumpers interface and moves it back to its original position
	layer.animate
		scaleY: 1
		scaleX: 1
		options:
			time: .3
			curve: Bezier.easeOut

# === hideBumpers ===
hideBumpers = (layer) ->
	# Takes a bumper on the bumpers interface and hides it
	layer.animate
		opacity: 0
		options:
			time: .3
			curve: Bezier.easeOut

# === showBumpers ===
showBumpers = (layer) ->
	# Takes a bumper on the bumpers interface and shows it (unhides it)
	layer.animate
		opacity: 1
		options:
			time: .3
			curve: Bezier.easeOut
	
#setup trail  and circles for drag
snailSetup(trail)
snailSetup(circles)

# === Touch Start Event === 
canvas.on Events.TouchStart, (e, layer) ->
	# Figure out where the user has clicked/tapped and record where they did in the interface
	touchEvent = Events.touchEvent(e)
	trackTaps(touchEvent, layer)
	moveToTap(circles)
	circles.visible = true
	initialY = tapY - trackingOffset - layer.y
	initialX = tapX - trackingOffset - layer.x
	stretchY = initialY
	stretchX = initialX
	whichBumper()
	checkScreenSwitch()
	released = false
	
	if wasTapIn(speedDetect)
		isSpeed = true
		isLane = false
				
	if wasTapIn(laneDetect)
		isSpeed = false
		isLane = true		
	
	# Case on the various bumpers and hide the irrelevant ones
	if wasTapIn(bottom_bumper) || wasTapIn(top_bumper)
		Speed3.stateCycle()
		for layer in sideBumpers
			hideBumpers(layer)

	if wasTapIn(left_bumper) || wasTapIn(right_bumper)
		Position1.stateCycle()
		for layer in vertical_bumpers
			hideBumpers(layer)

	trailSwitch = true

# === removeCommands ===
removeCommands = () ->
	# A wrapper to remove all of the commands sent to the CARLA car after a second
	setTimeout(CARLA_API.remove_all_commands, 1000)

# === Touch Move Event ===
canvas.on Events.TouchMove, (e, layer) ->
	# On a touch move event, find where the user tapped and try to determine the intent of their action, before passing off to CARLA.
	touchEvent = Events.touchEvent(e)
	if wasTapIn(speedDetect)
		isSpeed = true
		isLane = false
				
	if wasTapIn(laneDetect)
		isSpeed = false
		isLane = true
	lastY = tapY
	lastX = tapX
	trackTaps(touchEvent, layer)
	stretchY = tapY - trackingOffset - layer.y
	stretchX = tapX - trackingOffset - layer.x
	if currentScreen == "v2"
	# Find the distance between the move events
		deltaX = Math.abs(tapX - lastX)
		deltaY = Math.abs(tapY - lastY)
		# Calculating how much it takes to trigger an intent in a certain direction of the final interface
		yDistanceDownThreshold = 80
		yDistanceUpThreshold = 150
		xDistanceThreshold = 50

		# Case 1: Is this a lane adjustment
		if deltaX > deltaY and deltaX > xDistanceThreshold and isLane
			if tapX > lastX
				CARLA_API.move_right()
				CARLA_API.stop_moving_left()
			else
				CARLA_API.move_left()
				CARLA_API.stop_moving_right()
				
		# Case 2: Is this a speed up event
		else if deltaY > yDistanceUpThreshold and isSpeed and deltaY > deltaX
			if tapY < lastY
				CARLA_API.speed_up()
				CARLA_API.stop_slowing_down()
		
		# Case 3: Is this a slow down event?
		else if deltaY > yDistanceDownThreshold and isSpeed and deltaY > deltaX
			if tapY > lastY
				CARLA_API.slow_down()
				CARLA_API.stop_speeding_up()
#  Take the below case out for a convincing video		
		else
			removeCommands()
	
	# Move the trails for visual feedback near the user's hand
	if trailSwitch
		moveToTap(circles)
		moveToTap(trail)
	
	# Stretch the specific tapped bumper according to the user's hand Position1
	bumperStretch(bumperTapped)
	
	# Case on intention based on where the user initially began their movement
	if bumperTapped == bottom_bumper
		CARLA_API.stop_slowing_down()
		CARLA_API.speed_up()
	else if bumperTapped == top_bumper
		CARLA_API.slow_down()
		CARLA_API.stop_speeding_up()
	else if bumperTapped == left_bumper
		CARLA_API.stop_moving_left()
		CARLA_API.move_right()
	else if bumperTapped == right_bumper
		CARLA_API.stop_moving_right()
		CARLA_API.move_left()
	canvas.bringToFront()

# === Touch End Event
canvas.on Events.TouchEnd, () ->
	circles.visible  = false
	trail.visible = false
	trailSwitch = false

	# Return all of the bumpers to their original state
	for layer in bumpers
		returnBumpers(layer)
		
	for layer in sideBumpers
		showBumpers(layer)
	for layer in vertical_bumpers
		showBumpers(layer)		
	
	Speed3.states.switch "default"
	Position1.states.switch "default"
	
	if bumperTapped = bottom_bumper
		top_bumper.stateCycle()
	bumperTapped = null
	released = true
	removeCommands()

# Allow the finger trails to be draggable
trail.draggable.enabled = true
trail.draggable.constraints = {
	width: Screen.width
	height: Screen.height
}
trail.draggable.momentum = false
trail.bounce = false
trail.draggable.overdrag = false
		
trail.states =
	in:
		x: 219
		y: 22
		animationOptions:
			curve: "spring"
	default:
		x: Align.center
		y: Align.center()

layerArray = []

# Set the finger trail positions based on the coordinates of the touch event
trail.on "change:y", ->
	if trailSwitch
		trail1 = this.copy()
		trail1.visible = true
		trail2 = this.copy()
		trail2.visible = true
		trail1.y = (trail1.y + trail.height *2)
		trail2.y = (trail1.y *.9)
		trail2.x += (trail2.width*1.5)
		trail1.animate
			properties: scale: 0.3, opacity: 0, backgroundColor: 					"#D8D8D8" 
			delay: 0.3
			time: 0.1
			
		trail2.animate
			properties: scale: 0.3, opacity: 0, backgroundColor: 					"#D8D8D8" 
			delay: 0.3
			time: 0.1
		trail1.onAnimationEnd ->
			trail1.destroy()	
		
		trail2.onAnimationEnd ->
			trail2.destroy()
	
checkScreenSwitch()