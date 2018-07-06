#SETUP

{Pointer} = require "Pointer"

# Import file "Interactions_ORIGINAL"
sketch = Framer.Importer.load("imported/Interactions_ORIGINAL@1x", scale: 1)
# Import file "Interactions7.1v2"

# Import file "Interactions7.1v2"# Import file "Interactions7.1v2"

# Import file "Interactions7.1v2"


# Import file "Interactions7.1v2"
Utils.globalLayers(sketch)	

Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: 1536
	screenHeight: 2048
	borderColor: "FAFAFA"
	borderWidth: 0

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

# V1 Image Import
# 
# 
# right_bumper = new Layer
# 	width: 300
# 	height: 608
# 	scale: 0.5
# 	image: "images/right_bumper.png"
# 	x: 1250
# 	y: 1345
# 
# 
# left_bumper = new Layer
# 	width: 300
# 	height: 608
# 	image: "images/left_bumper.png"
# 	scale: 0.5
# 	y: 1345
# 	x: -38
# 	
# bottom_bumper = new Layer
# 	width: 1928
# 	height: 418
# 	scale: 0.5
# 	image: "images/bottom_bumper.png"
# 	x: -196
# 	y: 1770
# 
# top_bumper = new Layer
# 	width: 1928
# 	height: 418
# 	scale: 0.5
# 	image: "images/top_bumper.png"
# 	x: -196
# 	y: -46
# 	
# 



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
	width: 1868
	height: 2140
	opacity: 0


trail = new Layer
	backgroundColor: "rgba(94,167,207,1)"
	y: 0
	x: 0
	blur: 50
	borderRadius: 100
	height: 160
	width: 120
	opacity: 0.3
# 	x: Align.center
# 	y: Align.center()

snailSetup(trail)
snailSetup(circles)
# circles.parent = mainBoard
# circles.originX = .5
# circles.originY = .5
circles.bringToFront()

trail.visible = false


# track movements on touch move (circle and trail)
canvas.on Events.TouchMove, (e, layer) ->
	touchEvent = Events.touchEvent(e)
# 	print "map 1"
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
# 		print "map 2"
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
		trail.visible = false
		trailSwitch = true
		
		if checkTap(bottom_bumper)
			y1 = tapY - trackingOffset
			speedUpSwitch = true
		
		
		#^set flag so that when trail animation finishes and trail switch is false, you dont keep making trails below here
		canvas.on Events.TouchMove, (ev, layer) ->
			if speedUpSwitch
				y2 = tapY - trackingOffset
				dist = y1-y2
				bottom_bumper.animate
					scaleY: dist/80
					options:
						time: .1
			
			if trailSwitch
				trailSwitch = true
				shape.x = tapX - trackingOffset
				shape.y = tapY - trackingOffset
		canvas.bringToFront()
		#release and hide everthing
	
	#TOUCHEND
	canvas.on Events.TouchEnd, () ->
		
		if speedUpSwitch
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
# 				print "easter egg number " + easterEggCounter		
	#UGH HAVE TO LISTEN FOR CLICKS HERE			
				checkEasterEgg()
				#checkLowerCrest
				
		

trail.draggable.enabled = true
trail.draggable.constraints = {
	width: Screen.width
	height: Screen.height
}
trail.draggable.momentum = false
trail.bounce = false
trail.draggable.overdrag = false

# circle.onTap ->
# 	circle.stateCycle()
# 	print circle.x
		
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


