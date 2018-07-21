# Import file "Sketch Imports Second Screen"
{TextLayer, convertTextLayers} = require 'TextLayer'

sketch = Framer.Importer.load("imported/Sketch%20Imports%20Second%20Screen@1x", scale: 1)

Framer.Extras.Hints.disable()


SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536

button = new Layer


button2 = new Layer
	y: 414

button3 = new Layer
	y: 782



	
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
	
	
Top_Text = sketch.Top_Text.convertToTextLayer()
Bottom_Text = sketch.Bottom_Text.convertToTextLayer()

Straight_String.animationOptions = {time: .4, curve: Bezier.ease}

Top_Text.animationOptions = {time: 5, curve: Bezier.ease}
Bottom_Text.animationOptions = {time: 5, curve: Bezier.ease}
	
stringToAccel = () ->
	Transition_String.visible = true
	Transition_String.animate
		y: 230
		scaleX: .1
		opacity: 1


setDefaultState = () ->
	Top_Text.opacity = 0
	Bottom_Text.opacity = 0
	Top_Text.text = ""
	Bottom_Text.text = "CURRENT SPEED"
	Fill_Speed.visible = false
	sketch.Speed_Highlight.visible = true
	Up_String.visible = false
	Straight_String.opacity = 1
	Transition_String.opacity = 0

setAccelState = () ->
	Top_Text.text = "SPEED: ACCELERATING"
	Bottom_Text.text = "SETTING NEW SPEED"
	Up_String.visible = false
	Fill_Speed.visible = true
	sketch.Speed_Highlight.visible = false
	Straight_String.opacity = 0
	
	Bottom_Text.animate
		opacity: 1
	Top_Text.animate
		opacity: 1
		
		
	stringToAccel()
	


setDefaultState()

button.onClick ->
	setAccelState()
	Fill_Speed.visible = true
	Fill_Speed.animate
		scaleY: 9
		scaleX: 1.4
		y: 500
		options:
			time: 3.5
			
# if Fill_Speed.y >= Transition_String.y
# 	Transition_String.y =
		

