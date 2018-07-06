Framer.Device.customize
	devicePixelRatio: 1
	screenWidth: 1536
	screenHeight: 2048
	borderColor: "FAFAFA"
	borderWidth: 0

floodScreen = () ->
	flood.bringToFront()
	flood.animate
		opacity: 1
	
	bottomCrest.animate
		scale: 4
				
	topCrest.animate
		scale: 4
		
		

	
		

#SLIDER BOTTOM
slider = new SliderComponent
   width: 0
   height: 2418
   x: 788
   min: 10
   max: 1
   value: 1
   y: -442
   opacity: 0
   
   
   

slider.knob.width = Screen.width 
slider.knob.height = bottomCrest.height

 



slider.onValueChange ->
	value = slider.value
	bottomCrest.animate
		scaleY: value
		options:
			time: .05
	topCrest.animate
		scaleY: value
		options:
			time: 0
			curve: Bezier.easeOut

slider.knob.onDragEnd ->
	if slider.value > 4
		floodScreen()
	slider.animateToValue(1,{ curve: Bezier.easeOut, time: .3 })
	
reset = new Layer
	x: 1049
	y: 768
	width: 488
	height: 344
	opacity: 0

reset.onLongPress ->
	window.location.reload(false)
	
			
# #SLIDER TOP -- USE FOR SPEED LATER
# slider2 = new SliderComponent
#    width: 3
#    height: 1706
#    x: 768
# #    min:bottomCrest.height * 2
# #    max: bottomCrest.height 
#    min: 1
#    max: 5
#    value: 1
#    y: 258
#    rotation: 0
#  
#  slider2.knob.width = Screen.width  
#  slider2.knob.height = bottomCrest.height
#  slider2.knob.opacity = .5
# 
# 	
# 
# slider2.onValueChange ->
# 	value = slider2.value
# 	bottomCrest.animate
# 		scaleY: value
# 		options:
# 			time: .0
# 	topCrest.animate
# 		scaleY: value
# 		options:
# 			time: .0
