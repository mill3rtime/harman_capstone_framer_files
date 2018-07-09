#SETUP

{Pointer} = require "Pointer"

# Import the CARLA API and begin the server
CARLA_API = require "CARLA_API"
CARLA_API.begin_server()

# Import file "Interactions_ORIGINAL"
SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536
sketch = Framer.Importer.load("imported/Interactions_ORIGINAL@1x", scale: SKETCH_IMPORT_SCALE)
# Import file "Interactions7.1v2"

# Import file "Interactions7.1v2"# Import file "Interactions7.1v2"

# Import file "Interactions7.1v2"


# Import file "Interactions7.1v2"
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

tapX = 0
tapY = 0



easterEggCounter = 0
trailSwitch = false
currentScreen = "v1"
trackingOffset = 300

y1 = 0
y2 = 0
speedUpSwitch = false




checkTap = (shape) ->
	if (tapY >= shape.minY & tapY <= shape.maxY + 200) && (tapX >= shape.minX & tapX <= shape.maxX)
		return true


#Func: snailSetup
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
	

#Func: checkEasterEgg
#for some reason this counts in 2's

#SWITCH SCREENS
#redo this by passing in current screen and prev screen
checkEasterEgg = () ->	
	if easterEggCounter >= 6
		easterEggCounter = 0
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
	




canvas = new Layer
	width: Screen.width
	height: Screen.height
	opacity: 0


trail = new Layer
	backgroundColor: "rgba(34,167,207,1)"
	y: 0
	x: 0
	blur: 50
	borderRadius: 100
	height: 160
	width: 120
	opacity: 0.3

snailSetup(trail)
snailSetup(circles)

#TODO JS: look at pointer module and tablet detection
# track movements on touch move (circle and trail)
canvas.on Events.TouchMove, (e, layer) ->
	touchEvent = Events.touchEvent(e)
#TODO JS: encapsulate cord tracking
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = touchEvent.clientY - layer.y
# 		print "is mobile"
	else 
# 		print "not mobile"
		tapX = (touchEvent.offsetX)
		tapY = (touchEvent.offsetY)
	


#Func: setShowOnDrag
setShowOnDrag = (shape) -> 
	# circles but hide trail, it appears in wrong palce (top left)
	canvas.on Events.TouchStart, (e, layer) ->
		touchEvent = Events.touchEvent(e)
		if Utils.isPhone() || Utils.isTablet()
				tapX = (touchEvent.clientX - layer.x)
				tapY = touchEvent.clientY - layer.y
# 				print "is mobile"
		else 
# 			print "not mobile"
			tapX = (touchEvent.offsetX)
			tapY = (touchEvent.offsetY)
		shape.x = tapX - trackingOffset
		shape.y = tapY - trackingOffset
		shape.visible = true
		#TODO add param for visible on click
		trail.visible = false
		trailSwitch = true
		
		if checkTap(bottom_bumper)
			y1 = tapY - trackingOffset
			speedUpSwitch = true
		
		
		#^set flag so that when trail animation finishes and trail switch is false, you dont keep making trails below here
		
		#TODO put into function
		canvas.on Events.TouchMove, (ev, layer) ->
			if speedUpSwitch
			# Start speeding up
				CARLA_API.speed_up()
				y2 = tapY - trackingOffset
				dist = y1-y2
				bottom_bumper.animate
					scaleY: dist/80
					options:
						time: .1
			
			if trailSwitch
				trailSwitch = true
				# Case for V2, check if we are moving up or down
				if currentScreen == "v2"
					if shape.y > tapY - trackingOffset
						# Moving up on canvas
						CARLA_API.stop_speeding_up()
						CARLA_API.slow_down()
					else
						CARLA_API.stop_slowing_down()
						CARLA_API.speed_up()
				if currentScreen == 'v1'
					if shape.y < tapY - trackingOffset
						# Moving up on canvas
						CARLA_API.speed_up()
						CARLA_API.stop_slowing_down()
				shape.x = tapX - trackingOffset
				shape.y = tapY - trackingOffset
		canvas.bringToFront()
		#release and hide everthing
	
	#TOUCHEND
	canvas.on Events.TouchEnd, () ->
		
		if speedUpSwitch
			# Stop speeding up
			# CARLA_API Call to stop
			CARLA_API.stop_speeding_up()
			bottom_bumper.animate
				scaleY: 1
				options:
					time: .3
					curve: Bezier.easeOut
			speedUpSwitch = false
					

		shape.visible = false
		trailSwitch = false
		
		#TODO use the x and y values of 2 			shapes instes
		if tapX > -300 & tapX < 300
			if tapY > -300 & tapY < 300
			
				easterEggCounter += 1
	#UGH HAVE TO LISTEN FOR CLICKS HERE			
				checkEasterEgg()
				
		

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
		

setShowOnDrag(trail)
setShowOnDrag(circles)


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


