#SETUP
# Import file "bidirectional choice"
sketch = Framer.Importer.load("imported/bidirectional%20choice@1x", scale: 1)
#SETUP

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


tapX = 0
tapY = 0


trackingOffset = 300
touching = false

trackTaps = (touchEvent, layer) ->
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = touchEvent.clientY - layer.y
		
# 		print "is mobile"
	else 
# 		print "not mobile"
		tapX = (touchEvent.offsetX)
		tapY = (touchEvent.offsetY)



canvas.on Events.TouchStart, (e, layer) ->
	touchEvent = Events.touchEvent(e)
	touching = true
	trackTaps(touchEvent, layer)
	print tapX
	
canvas.on Events.TouchEnd, (e, layer) ->
	touchevent = Events.touchEvent(escape)
	