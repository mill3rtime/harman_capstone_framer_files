#SETUP
# Import file "bidirectional choiceRR"
sketch = Framer.Importer.load("imported/bidirectional%20choiceRR@1x", scale: 1)
#SETUP

# limit_1 = new Layer
# 	y: 603
# 	width: 1536
# 	height: 29
# 	
# limit_2 = new Layer
# 	y: 443
# 	width: 1536
# 	height: 29
	

# sketch.Yes.visible = true
# sketch.Yes.bringToFront()
# 
# sketch.Pass_Bus.visible = false
# sketch.Take_Right.x = 0
# 
# sketch.Yes.animate
# 	y: 525
# 	x: 197
# 	width: 821
# 	height: 461
	

#disable purple hints
Framer.Extras.Hints.disable()


# Import the CARLA API and begin the server

# Import file "Interactions_ORIGINAL"
SKETCH_IMPORT_SCALE = 1.1
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536



Utils.globalLayers(sketch)

BG = sketch.Background_Gradient

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

#TODO
#remove hack for preveting opposite motion and do it based on drag direction.


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
checkDevice()

yesArray = [yes_1, yes_2, yes_3, yes_4]
noArray = [no_1, no_2, no_3, no_4]


for layer in yesArray
	animationOptions:
		curve: Bezier.linear
		time: .2

yes_1_start = yes_1.y
yes_2_start = yes_2.y
yes_3_start = yes_3.y
yes_4_start = yes_4.y
Yes_start = Yes.y

no_1_start = no_1.y
no_2_start = no_2.y
no_3_start = no_3.y
no_4_start = no_4.y
No_start = No.y
		
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
		y: (layer.y + 2* (tapY2 - oldTapY2)/1.7)
		options:
			time: 0
			curve: Bezier.linear
	
canvas.on Events.TouchStart, (e, layer) ->
	touchEvent = Events.touchEvent(e)
	touching = true

checkMove = () ->
	if yes_4.maxY < yes_4.height
		moveLayer(Yes)
	if yes_4.maxY < yes_3.height
		moveLayer(yes_3)

		for layer in yesArray
			layer.animate
				brightness: layer.brightness + 5
				options:
					time: .2
					curve: Bezier.ease
		
		if yes_3.maxY < yes_2.height
			moveLayer(yes_2)
			if yes_2.maxY < yes_1.height
				moveLayer(yes_1)
				
	if no_1.minY > no_1_start
		moveLayer(No)
	if no_1.minY > (no_2.maxY- no_2.height)
		moveLayer(no_2)
		
		for layer in noArray
			layer.animate
				brightness: layer.brightness + 5
				options:
					time: .2
					curve: Bezier.ease
	
		if no_2.minY > (no_3.maxY - no_3.height)
			moveLayer(no_3)
			if no_3.minY > (no_4.maxY - no_4.height)
				moveLayer(no_4)


				

	
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
		#prevent downward/upward motion of other side of screen
		if yes_4.y > yes_4_start
			yes_4.y = yes_4.start
		if yes_3.y > yes_3_start
			yes_3.y = yes_3.start
		if yes_2.y > yes_2_start
			yes_2.y = yes_2.start
		if yes_1.y > yes_1_start
			yes_1.y = yes_1.start

		if no_1.minY < no_1_start
			no_1.y = no_1_start	
		if no_2.minY < no_2_start
			no_2.y = no_2_start	
		if no_3.minY < no_3_start
			no_3.y = no_3_start
		if no_4.minY < no_4_start
			no_4.y = no_4_start		

		moveLayer(yes_4)
		moveLayer(no_1)
		#only y4 uses move(). all others chain off of previous curves position
		checkMove()
	
	
canvas.on Events.TouchEnd, (e, layer) ->
	touching = false
	dist = 0
	
	for layer in yesArray
		layer.opacity = 1
	#return yes's to original position
	yes_4.animate
		y: yes_4_start
	yes_3.animate
		y: yes_3_start
	yes_2.animate
		y: yes_2_start
	yes_1.animate
		y: yes_1_start
	Yes.animate
		y: Yes_start
		
	no_4.animate
		y: no_4_start
	no_3.animate
		y: no_3_start
	no_2.animate
		y: no_2_start
	no_1.animate
		y: no_1_start
	No.animate
		y: No_start
		
	for layer in yesArray
		layer.animate
			brightness: 100
			options:
				time: 2
				curve: Bezier.ease

	for layer in noArray
		layer.animate
			brightness: 100
			options:
				time: 2
				curve: Bezier.ease
