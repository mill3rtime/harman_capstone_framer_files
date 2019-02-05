{Firebase} = require 'firebase'


firebase = new Firebase
  projectID: "fir-framertest"
  secret: "E5YP9evEPUlk9Olv0PiA5A62kWF2GjovaQkLPSRl" # 2) ... Project Settings → Service Accounts → Database Secrets → Show (mouse-over)

layer = new Layer
val = 0

layer.onClick ->
	val += 1
	print "local val is " + val
	valExtra = val + 1
	firebase.put("/value", valExtra)

layer2 = new Layer
	x: 321
	backgroundColor: "rgba(39,0,197,0.5)"

#works
layer2. onClick ->
	firebase.get "/value", (valuez) ->
		print valuez


firebase.onChange "/value", (valueG) ->
	if valueG == 7 + 1
		print "conditional"
		

layer.draggable = true

layer.on "change:y", ->
	posY = layer.y
	firebase.put("/y", posY)

firebase.onChange "/y", (newY) ->
	layer2.y = newY
	
