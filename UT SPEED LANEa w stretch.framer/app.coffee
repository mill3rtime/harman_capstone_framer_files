#SETUP

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

defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

screenWidth = Framer.Device.screen.width
widthScale = defaultWidth / screenWidth

#TODO JS: 
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


tapX = 0
tapY = 0


#	
#TODO 
#touch start should come before touch move	
#add param for visible on click for snail setup
#use tap check for easter egg functions
# disable purple box
# when lane adjust is tapped make other options disapear and vic versa
#back to speed and nudge
# make hideSideBumper() that switches sttes animated
#TODO increase target for side bumpers

# #COMMIT
#fixed screen switching and changed related func and var names
#disable purple hints


#GLOBAL VARIABLES
speedUpSwitch = false
switchScreenCounter = 0
trailSwitch = false
currentScreen = "v1"
trackingOffset = 300
bumperTapped = null
initialY = 0
initialX = 0
y2 = 0
x2 = 0
bumpers = [bottom_bumper,top_bumper,left_bumper,right_bumper]
sideBumpers = [right_bumper,left_bumper, Position1]
vertical_bumpers = [top_bumper, bottom_bumper, Speed3]
stretchY = 0
stretchX = 0

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
	



switchScreenButton = new Layer
	visible: false
	width: 316
	height: 294
	

#Func for Setting tapX and tapY
trackTaps = (touchEvent, layer) ->
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = touchEvent.clientY - layer.y
		
# 		print "is mobile"
	else 
# 		print "not mobile"
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

#wasTapIn()
#takes a shape and returns t/f if click is inside of it (using tapY, tapX)
wasTapIn = (shape) ->
	if (tapY >= shape.minY & tapY <= shape.maxY + 200) && (tapX >= shape.minX &
	tapX <= shape.maxX)
		return true

#whichBumper()
whichBumper = () ->
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
	

#bumperStretch()
bumperStretch = (bumperTapped) ->

	
	if bumperTapped == bottom_bumper
			# Start speeding up
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
# 					CARLA_API.stop_slowing_down() 
# 					CARLA_API.speed_up()
				bottom_bumper.onAnimationEnd -> 
					if released
						top_bumper.animate
							y: startYTop
							options:
								time: .4
								curve: Bezier.ease

						
	if bumperTapped == top_bumper
	# Start speeding up
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
# 			CARLA_API.slow_down() 
# 			CARLA_API.stop_speeding_up()
			bottom_bumper.animate
				y: bottom_bumper.y + (dist * 3)
		top_bumper.onAnimationEnd ->
			if released
				bottom_bumper.animate
					y: startYBottom
					options:
						time: .4
						curve: Bezier.ease
				
	if bumperTapped == left_bumper
		dist = stretchX - initialX
		left_bumper.animate
			scaleX: 1 + dist/80
			scaleY: 1 + dist/240
			options:
				time: .1
				
	if bumperTapped == right_bumper
		dist = initialX - stretchX
		right_bumper.animate
			scaleX: 1 + dist/80
			scaleY: 1 + dist/240
			opacity: 1
			options:
				time: .1


#checkSwitchScreens
#SWITCH SCREENS
#redo this by passing in current screen and prev screen
checkScreenSwitch = () ->
	if wasTapIn(switchScreenButton)
		switchScreenCounter++
	if switchScreenCounter >= 4
		switchScreenCounter = 0
		if currentScreen == "v2"
			sketch.Binary_1.x = 0
			sketch.Binary_1.y = 0
			sketch.Version2.visible = false
			sketch.Binary_1.visible = true
			circles.parent = sketch.Binary_1
			currentScreen = "Binary"
			#test
			sketch.lower_crest.height = 100
		
		else if currentScreen == "v1"
			sketch.Version2.x = 0
			sketch.Version2.y = 0
			sketch.Version_One_Default.visible = false
			sketch.Version2.visible = true
			circles.parent = sketch.Version2
			currentScreen = "v2"

		else if currentScreen == "Binary"
			sketch.Version_One_Default.visible.x = 0
			sketch.Version_One_Default.visible.y = 0
			sketch.Binary_1.visible = false
			sketch.Version_One_Default.visible = true
			circles.parent = sketch.Version_One_Default
			currentScreen = "v1"
# 		sketch.Version_One_Default.
		#put transition to next screen here
	
	
		
#moveToTap()
moveToTap = (visual) ->
	visual.x = tapX - trackingOffset
	visual.y = tapY - trackingOffset

#returnBumpers()
returnBumpers = (layer) ->
	layer.animate
		scaleY: 1
		scaleX: 1
		options:
			time: .3
			curve: Bezier.easeOut
	


hideBumpers = (layer) ->
	layer.animate
		opacity: 0
		options:
			time: .3
			curve: Bezier.easeOut


showBumpers = (layer) ->
	layer.animate
		opacity: 1
		options:
			time: .3
			curve: Bezier.easeOut
	
#setup trail  and circles for drag
snailSetup(trail)
snailSetup(circles)

canvas.on Events.TouchStart, (e, layer) ->
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
	
	
	if wasTapIn(bottom_bumper) || wasTapIn(top_bumper)
		Speed3.stateCycle()
		for layer in sideBumpers
			hideBumpers(layer)

	if wasTapIn(left_bumper) || wasTapIn(right_bumper)
		Position1.stateCycle()
		for layer in vertical_bumpers
			hideBumpers(layer)

	
	trailSwitch = true



canvas.on Events.TouchMove, (e, layer) ->
	touchEvent = Events.touchEvent(e)
	trackTaps(touchEvent, layer)
	stretchY = tapY - trackingOffset - layer.y
	stretchX = tapX - trackingOffset - layer.x
	if currentScreen == "v2"
		deltaX = Math.abs(tapX - initialX)
		deltaY = Math.abs(tapY - initialY)
		yDistanceThreshold = 100
		xDistanceThreshold = 10
		if deltaY > yDistanceThreshold
			if tapY > initialY
				CARLA_API.slow_down()
				CARLA_API.stop_speeding_up()
			else
				CARLA_API.stop_slowing_down()
				CARLA_API.speed_up()
		else if deltaX > xDistanceThreshold
			if tapX > initialX
				CARLA_API.stop_moving_left()
				CARLA_API.move_right()
			else
				CARLA_API.stop_moving_right()
				CARLA_API.move_left()
		else
			CARLA_API.remove_all_commands()
	if trailSwitch
		moveToTap(circles)
		moveToTap(trail)
	bumperStretch(bumperTapped)
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

canvas.on Events.TouchEnd, () ->
	circles.visible  = false
	trail.visible = false
	trailSwitch = false

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
	CARLA_API.remove_all_commands()

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


# setShowOnDrag(circles)
# setShowOnDrag(trail)
#fix and use arrays

layerArray = []

trail.on "change:y", ->
	if trailSwitch
		trail1 = this.copy()
		trail1.visible = true
# 		layerArray.push trail1
		trail2 = this.copy()
		trail2.visible = true
# 		layerArray.push trail2
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
	


# TODO: set a switch for x change or why change depnindg on stating point


