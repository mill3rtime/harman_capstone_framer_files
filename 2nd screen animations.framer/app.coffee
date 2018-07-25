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

speedArray = [sketch.Speed_Text,sketch.MPH, sketch.Speed_Highlight]

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


pulse = sketch.Speed_Highlight
# Straight_String.animationOptions = {time: .4, curve: Bezier.ease}
# 
# Top_Text.animationOptions = {time: 3, curve: Bezier.ease}
# Bottom_Text.animationOptions = {time: 3, curve: Bezier.ease}
done = false
block = false

stringStart = Transition_String.maxY

startSpeed = 36
downSpeed = 24
upSpeed = 48
stringCount = 0

///COUNTING VARIABLES///

newSpeed = 0

rangeUp =
	min: startSpeed
	max: upSpeed
	
rangeDown =
	min: downSpeed
	max: startSpeed
	
stringTime1 = 3
fillTime1 = 6
speed = null
	
///STATES///
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
			
	
	
///Functions///

setDefaultState = () ->
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
	Transition_String. rotation = 0
	sketch.Transition_String.animate
		scaleY: 4
		minY: 130
		options:
			time: stringTime1
			curve: Bezier.easeIn

stringToDecel = () ->
	Transition_String.visible = true
	sketch.Transition_String.opacity = 1
	Transition_String. rotation = 180
	sketch.Transition_String.animate
		scaleY: 4
		minY: Dividing_Bar.y - 220
		options:
			time: stringTime1
			curve: Bezier.easeIn

#Also decel fill
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
				curve: Bezier.easeIn
				time: fillTime1
				
	if speed == "up"
		sketch.Fill_Speed.animate
			scaleY: 5.8
			scaleX: 1.15
			maxY: Transition_String.maxY
			y: 200
			options: 
				curve: Bezier.easeIn
				time: fillTime1
			
pulseAnimation = () ->
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
			
///COUNTING FUNCTIONS///			

newSpeed = 0

countUp = () ->
	time = (stringTime1/(upSpeed - startSpeed))
	print time
	for i in [0..(rangeUp.max-rangeUp.min)]
		do (i) ->
			Utils.delay time *i, ->
				newSpeed = startSpeed+i
				Speed_Text.text = newSpeed

countDown = () ->
	time = (stringTime1/(startSpeed - downSpeed))
	for i in [0..(rangeDown.max-rangeDown.min)]
		do (i) ->
			Utils.delay time*i, ->
				newSpeed = startSpeed-i
				Speed_Text.text = newSpeed
	print "go"				
			

///UI///
setDefaultState()
sketch.MPH.x = 160

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



Transition_String.onAnimationEnd ->
	stringCount += 1
	if stringCount == 2
		setDefaultState()
		stringCount = 0
		block = false

	
		

Fill_Speed.onAnimationEnd ->
	if !done
		pulseAnimation()
		done = true 
		Utils.delay 3, ->
			Fill_Speed.states.switchInstant "home"
		# 	Fill_Speed.off(Events.AnimationEnd)
			Transition_String.states.switch "home"
			
			startSpeed = newSpeed
			upSpeed = startSpeed + 12
			downSpeed = startSpeed - 12

			if speed = "down"
				Fill_Speed.rotation = 180

			if speed = "up"
				Fill_Speed.rotation = 0
		
					
	



# Transition_String.on "change:y", ->
# # 	Speed_Text.text = (Utils.round(Transition_String.y))
# 	for i in [0..(range.max-range.min)]
# 	do (i) ->
# 		Utils.delay time*i, ->
# 			text.html = range.min+i
# 	

# if Fill_Speed.y >= Transition_String.y
# 	Transition_String.y =
		

