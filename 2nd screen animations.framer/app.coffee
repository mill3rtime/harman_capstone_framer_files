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
	
///Variables///	
Top_Text = sketch.Top_Text.convertToTextLayer()
Bottom_Text = sketch.Bottom_Text.convertToTextLayer()
Speed_Text = sketch.Speed_Text.convertToTextLayer()

Straight_String.animationOptions = {time: .4, curve: Bezier.ease}

Top_Text.animationOptions = {time: 3, curve: Bezier.ease}
Bottom_Text.animationOptions = {time: 3, curve: Bezier.ease}
stringStart = Transition_String.maxY
startSpeed = 34

rangeUp =
	min: startSpeed
	max: 50
	
rangeDown =
	min: 12
	max: startSpeed

	
	
time = 0.2

speed = null
	
///Functions///

setDefaultState = () ->
	Top_Text.text = "SELF DRIVING: ON"
	Bottom_Text.text = "CURRENT SPEED"
	Bottom_Text.opacity = 1
	Bottom_Text.visible = true
	Fill_Speed.visible = true
	sketch.Speed_Highlight.visible = true
	Up_String.visible = false
	Straight_String.opacity = 1
	Transition_String.opacity = 0
	Fill_Speed.visible = false


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
	Transition_String.animate
		scaleY: 4
		minY: 130

stringToDecel = () ->
	Transition_String.visible = true
	Transition_String. opacity = 1
	Transition_String.animate
		scaleY: -4
		minY: Dividing_Bar.y - 220

	
fillToAccel = () ->
	if speed == "down"
		Fill_Speed.y = 0
		Fill_Speed.rotation = 180
	Fill_Speed.visible = true
	if speed == "down"
		print "down"
		Fill_Speed.animate
			scaleY: 6
			scaleX: 1.15
			y: Transition_String.maxY + 100			
			options:
				time: 4
	if speed == "up"
		Fill_Speed.animate
			scaleY: 5.8
			scaleX: 1.15
			maxY: Transition_String.maxY
			y: 200
			options:
				time: 5
			
			
countUp = () ->
	for i in [0..(rangeUp.max-rangeUp.min)]
		do (i) ->
			Utils.delay time*i, ->
				Speed_Text.text = rangeUp.min+i

countDown = () ->
	for i in [startSpeed..0]
		do (i) ->
			Utils.delay .1*i, ->
				Speed_Text.text = startSpeed-i
	
setDefaultState()



///UI///
button.onClick ->
	speed = "up"
	setAccelState()
	stringToAccel()
	fillToAccel()
	countUp()

button2.onClick ->
	speed = "down"
	setAccelState()
	stringToDecel()
	fillToAccel()
	countDown()

Fill_Speed.onAnimationEnd ->	
	setDefaultState()
	
	


# Transition_String.on "change:y", ->
# # 	Speed_Text.text = (Utils.round(Transition_String.y))
# 	for i in [0..(range.max-range.min)]
# 	do (i) ->
# 		Utils.delay time*i, ->
# 			text.html = range.min+i
# 	

# if Fill_Speed.y >= Transition_String.y
# 	Transition_String.y =
		

