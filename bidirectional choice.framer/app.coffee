#SETUP
# Import file "bidirectional choice"
sketch = Framer.Importer.load("imported/bidirectional%20choice@1x", scale: 1)

# limit_1 = new Layer
# 	y: 603
# 	width: 1536
# 	height: 29
# 	
# limit_2 = new Layer
# 	y: 443
# 	width: 1536
# 	height: 29
	


#disable purple hints
Framer.Extras.Hints.disable()


# Import the CARLA API and begin the server

# Import file "Interactions_ORIGINAL"
SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536


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



# to make other artboards visible make xy = 0 and current board not visible.

canvas = new Layer
	width: Screen.width
	height: Screen.height
	opacity: 0
	x: 1
	y: 283



checkDevice = () ->
	if Utils.isPhone() || Utils.isTablet()
		touching = true
	else
		touching = false

trackingOffset = 300
touching = null

yesArray = [yes_1, yes_2, yes_3, yes_4]

for layer in yesArray
	animationOptions:
		curve: Bezier.linear
		time: .2

yes_1_start = yes_1.y
yes_2_start = yes_2.y
yes_3_start = yes_3.y
yes_4_start = yes_4.y


print yes_1.y


checkDevice()
		
#this is diff than original binary where tapx is global. now it is in the scope of track taps.

oldTapY2 = 0
tapY1 = 0
tapY2 = 0
dist = ""


#return Y cord
trackY = (touchEvent, layer, target) ->
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = (touchEvent.clientY - layer.y)		
# 		print "is mobile"
	else 
# 		print "not mobile"
		tapX = (touchEvent.offsetX)
		tapY = (touchEvent.offsetY)
	
	return tapY

moveLayer = (layer) ->

	layer.animate
		y: (layer.y + 2* (tapY2 - oldTapY2))
		options:
			time: 0
			curve: Bezier.linear
	
canvas.on Events.TouchStart, (e, layer) ->
	touchEvent = Events.touchEvent(e)
	touching = true
	

checkMove = () ->
	if yes_4.maxY < yes_3.height
		moveLayer(yes_3)
		if yes_3.maxY < yes_2.height
			moveLayer(yes_2)
			if yes_2.maxY < yes_1.height
				moveLayer(yes_1)
	
canvas.on Events.TouchMove, (e, layer) ->
# 		testLayer.y = Utils.modulate(event.offsetY, [0, canvas.height], [0, canvas.height] )
	
	if touching
		touchEvent = Events.touchEvent(e)
		oldTapY2 = tapY2
		tapY2 = trackY(touchEvent, layer)
		if oldTapY2	== 0
			oldTapY2 = tapY2
		threshold = 50
		if Math.abs(oldTapY2 - tapY2) > threshold
			oldTapY2 = tapY2
# 		print dist
		moveLayer(sketch.yes_4)
		checkMove()
		print yes_4.y
	
canvas.on Events.TouchEnd, (e, layer) ->
	touching = false
	dist = 0
	
	
	yes_4.animate
		y: yes_4_start
	yes_3.animate
		y: yes_3_start
	yes_2.animate
		y: yes_2_start
	yes_1.animate
		y: yes_1_start