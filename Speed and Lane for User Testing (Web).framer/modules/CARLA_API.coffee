# === CARLA Networking API ===

# An interface to interact with the CARLA Driving Simulator based on the MHCI Protocol

# The below IP/PORT will vary
IP_PORT = 'http://172.25.2.19:8080'
DEBUG = false

# === run_ajax ===
run_ajax = (msg) ->
  # A generic AJAX wrapper to perform POST requests to the Python HTTP Server
  console.log(msg)
  if DEBUG
    # ...
    return
  # Perform an AJAX post request with our message
  $.ajax
    url: IP_PORT
    data: msg
    method: 'POST'
    crossOrigin: true
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error')
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      console.log('yes')
      console.log(data)
      $('body').append "Successful AJAX call: #{data}"  

# Begin the server with this command
exports.begin_server = ->
  run_ajax('startserver')

# Speed up
exports.speed_up = ->
  run_ajax('forward')

# Stop speeding up
exports.stop_speeding_up = ->
  run_ajax('forward_stop')

# Slow down
exports.slow_down = ->
  run_ajax('backward')

# Stop slowing down
exports.stop_slowing_down = ->
  run_ajax('backward_stop')

# Adjust left in lane
exports.move_left = ->
  run_ajax('left')

# Stop adjusting
exports.stop_moving_left = ->
  run_ajax('left_stop')

# Adjust right in lane
exports.move_right = ->
  run_ajax('right')

# Stop adjusting
exports.stop_moving_right = ->
  run_ajax('right_stop')

# Emergency stop
exports.hard_stop = ->
  run_ajax('stop')

# Clear all commands sent to the car
exports.remove_all_commands = ->
  run_ajax('clear')

exports.toggle_autopilot = ->
  run_ajax('enable_ap')
