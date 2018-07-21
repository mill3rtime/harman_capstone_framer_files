IP_PORT = 'http://172.25.2.19:8080'
DEBUG = false

run_ajax = (msg) ->
  console.log(msg)
  if DEBUG
    # ...
    return
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

exports.begin_server = ->
  run_ajax('startserver')

exports.speed_up = ->
  run_ajax('forward')

exports.stop_speeding_up = ->
  run_ajax('forward_stop')

exports.slow_down = ->
  run_ajax('backward')

exports.stop_slowing_down = ->
  run_ajax('backward_stop')

exports.move_left = ->
  run_ajax('left')

exports.stop_moving_left = ->
  run_ajax('left_stop')

exports.move_right = ->
  run_ajax('right')

exports.stop_moving_right = ->
  run_ajax('right_stop')

exports.hard_stop = ->
  run_ajax('stop')

exports.remove_all_commands = ->
  run_ajax('clear')

exports.toggle_autopilot = ->
  run_ajax('enable_ap')
