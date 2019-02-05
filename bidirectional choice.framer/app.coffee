# Import file "bidirectional choice"
sketch = Framer.Importer.load("imported/bidirectional%20choice@1x", scale: 1)
# Import file "bidirectional choice"

# # Binary Decision UI
# Here we define the interaction for the binary "go/don't go" decision in an AV. Sliding up results in performing the confirmation action, while sliding back results in the denial option.

# # TODO
# Remove hack for preveting opposite motion and do it based on drag direction.
# Also update what happens in the event of a dismissal (pull down)

# Import Sketch file `bidirectional choice`
SKETCH_IMPORT_SCALE = 1.1


# Disable purple hints
Framer.Extras.Hints.disable()

# Define the iPad width and height
IPAD_HEIGHT = 2048
IPAD_WIDTH = 1536

Utils.globalLayers(sketch)

BG = sketch.Background_Gradient

# Scale the display width and height by our sketch import scale
defaultWidth = IPAD_WIDTH * SKETCH_IMPORT_SCALE
defaultHeight = IPAD_HEIGHT * SKETCH_IMPORT_SCALE

Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: defaultWidth
	screenHeight: defaultHeight

canvas = new Layer
	width: defaultWidth
	height: defaultHeight
	opacity: 0
	x: 1
	y: 50

sketch.Passing_Bus.opacity = 0
sketch.Home.opacity = 0

# === checkDevice ===
checkDevice = () ->
	# Checks to see if the prototype is running on a tablet before setting an "always touching" parameter, otherwise we will listen for click events.
	if Utils.isPhone() || Utils.isTablet()
		touching = true
	else
		touching = false

# Set some constants for tracking the user's position on the interface
trackingOffset = 300
touching = false
checkDevice()
offScreen = false
oldTapY2 = 0
tapY1 = 0
tapY2 = 0
dist = ""

# Define several intermediate states for the yes and no transitions while interacting
yesArray = [yes_1, yes_2, yes_3, yes_4, Yes]
noArray = [no_1, no_2, no_3, no_4, No]

# Animate these intermediate transitions
for layer in yesArray
	animationOptions:
		curve: Bezier.linear
		time: .2
		
# Take the vertical positions of each artboard for easier use later
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

bottomBorder = no_4.maxY

# === trackY ===
trackY = (touchEvent, layer, target) ->
	# Set the x and y coordinates of the backend based on where the user has tapped
	if Utils.isPhone() || Utils.isTablet()
		tapX = (touchEvent.clientX - layer.x)
		tapY = (touchEvent.clientY - layer.y)		
	else 
		tapX = (touchEvent.offsetX)
		tapY = (touchEvent.offsetY)
	return tapY
	
# === moveLayer ===
moveLayer = (layer) ->
	# Generic function to animate the given layer to the provided y point
	sensitivity = 1.2
	layer.animate
		y: (layer.y + 2* (tapY2 - oldTapY2)/sensitivity)
		options:
			time: 0
			curve: Bezier.linear

# === hideControl ===
hideControl = () ->
	# Hide all of the transitional state artboards from the start
	for layer in noArray
		layer.visible = false
	for layer in yesArray
		layer.visible = false
			
# === comfirmDeny ===
confirmDeny = () ->
	# Check that the user does, in fact, want to perform the deny action for this binary action
	# TODO: Change back to 0 for the full curve effect
	denyThresholdPx = 200
	borderOffset = 200
	if yes_4.maxY < denyThresholdPx
		offScreen = true
		hideControl()
		sketch.Passing_Bus.x = 0
		sketch.Passing_Bus.y = 0
		Passing_Bus.animate
			opacity: 1
			options:
				time: 1
				curve: Bezier.easeInOut
	
	if no_1.minY > bottomBorder - borderOffset
		hideControl()
		sketch.Home.x = 0
		sketch.Home.y = 0
		Home.animate
			opacity: 1
			options:
				time: 2
				curve: Bezier.easeInOut
		

	
# === Touch Start Event ===
canvas.on Events.TouchStart, (e, layer) ->
	# Capture where the user has touched and indicate the touching has began
	touchEvent = Events.touchEvent(e)
	touching = true

# === checkMove ===
checkMove = () ->
	# Check how the user is moving, and update the UI to respond
	# Moving towards the "yes" option
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
	# Moving towards the "no" option
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

# === Touch Move Event ===
canvas.on Events.TouchMove, (e, layer) ->
	# As the user is touching the UI, track their updated hand position and move the UI accordingly
	if touching
		touchEvent = Events.touchEvent(e)
		oldTapY2 = tapY2
		tapY2 = trackY(touchEvent, layer)
		if oldTapY2	== 0
			oldTapY2 = tapY2
		threshold = 50
		# Find the distance between their last tracked touching event and now, and make sure it is smooth enough to make sense
		if Math.abs(oldTapY2 - tapY2) > threshold
			oldTapY2 = tapY2
		# prevent downward/upward motion of other side of screen
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
		
		# Checking here for simulator
		confirmDeny()

# === Touch End Event ===
canvas.on Events.TouchEnd, (e, layer) ->
	# Reset all of our artboards to the starting position, and indicate the touching has ended
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
	
	confirmDeny()
	
	# Animate the layers back to their starting position
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
				
