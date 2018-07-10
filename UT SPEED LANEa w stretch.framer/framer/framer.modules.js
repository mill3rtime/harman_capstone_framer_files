require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"CARLA_API":[function(require,module,exports){
var DEBUG, IP_PORT, run_ajax;

IP_PORT = 'http://172.25.2.19:8080';

DEBUG = true;

run_ajax = function(msg) {
  if (DEBUG) {
    return;
  }
  return $.ajax({
    url: IP_PORT,
    data: msg,
    method: 'POST',
    crossOrigin: true,
    error: function(jqXHR, textStatus, errorThrown) {
      console.log('error');
      return $('body').append("AJAX Error: " + textStatus);
    },
    success: function(data, textStatus, jqXHR) {
      console.log('yes');
      console.log(data);
      return $('body').append("Successful AJAX call: " + data);
    }
  });
};

exports.begin_server = function() {
  return run_ajax('startserver');
};

exports.speed_up = function() {
  return run_ajax('forward');
};

exports.stop_speeding_up = function() {
  return run_ajax('forward_stop');
};

exports.slow_down = function() {
  return run_ajax('backward');
};

exports.stop_slowing_down = function() {
  return run_ajax('backward_stop');
};

exports.move_left = function() {
  return run_ajax('left');
};

exports.stop_moving_left = function() {
  return run_ajax('left_stop');
};

exports.move_right = function() {
  return run_ajax('right');
};

exports.stop_moving_right = function() {
  return run_ajax('right_stop');
};

exports.hard_stop = function() {
  return run_ajax('stop');
};

exports.remove_all_commands = function() {
  return run_ajax('clear');
};

exports.toggle_autopilot = function() {
  return run_ajax('enable_ap');
};


},{}],"Pointer":[function(require,module,exports){
exports.Pointer = (function() {
  var clientCoords, coords, offsetArgumentError, offsetCoords, screenArgumentError;

  function Pointer() {}

  Pointer.screen = function(event, layer) {
    var e, screenCoords;
    if (!((event != null) && (layer != null))) {
      screenArgumentError();
    }
    e = offsetCoords(event);
    if (e.x && e.y) {
      screenCoords = layer.screenFrame;
      e.x += screenCoords.x;
      e.y += screenCoords.y;
    } else {
      e = clientCoords(event);
    }
    return e;
  };

  Pointer.offset = function(event, layer) {
    var e, targetScreenCoords;
    if (!((event != null) && (layer != null))) {
      offsetArgumentError();
    }
    e = offsetCoords(event);
    if (!((e.x != null) && (e.y != null))) {
      e = clientCoords(event);
      targetScreenCoords = layer.screenFrame;
      e.x -= targetScreenCoords.x;
      e.y -= targetScreenCoords.y;
    }
    return e;
  };

  offsetCoords = function(ev) {
    var e;
    e = Events.touchEvent(ev);
    return coords(e.offsetX, e.offsetY);
  };

  clientCoords = function(ev) {
    var e;
    e = Events.touchEvent(ev);
    return coords(e.clientX, e.clientY);
  };

  coords = function(x, y) {
    return {
      x: x,
      y: y
    };
  };

  screenArgumentError = function() {
    error(null);
    return console.error("Pointer.screen() Error: You must pass event & layer arguments. \n\nExample: layer.on Events.TouchStart,(event,layer) -> Pointer.screen(event, layer)");
  };

  offsetArgumentError = function() {
    error(null);
    return console.error("Pointer.offset() Error: You must pass event & layer arguments. \n\nExample: layer.on Events.TouchStart,(event,layer) -> Pointer.offset(event, layer)");
  };

  return Pointer;

})();


},{}],"myModule":[function(require,module,exports){
exports.myVar = "myVariable";

exports.myFunction = function() {
  return print("myFunction is running");
};

exports.myArray = [1, 2, 3];


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uL0Ryb3Bib3gvRE9DVU1FTlRTIE9OIERCIEFORCBMT0NBTC9HSC9oYXJtYW5fY2Fwc3RvbmVfZnJhbWVyX2ZpbGVzL1VUIFNQRUVEIExBTkVhIHcgc3RyZXRjaC5mcmFtZXIvbW9kdWxlcy9teU1vZHVsZS5jb2ZmZWUiLCIuLi8uLi8uLi8uLi8uLi9Ecm9wYm94L0RPQ1VNRU5UUyBPTiBEQiBBTkQgTE9DQUwvR0gvaGFybWFuX2NhcHN0b25lX2ZyYW1lcl9maWxlcy9VVCBTUEVFRCBMQU5FYSB3IHN0cmV0Y2guZnJhbWVyL21vZHVsZXMvUG9pbnRlci5jb2ZmZWUiLCIuLi8uLi8uLi8uLi8uLi9Ecm9wYm94L0RPQ1VNRU5UUyBPTiBEQiBBTkQgTE9DQUwvR0gvaGFybWFuX2NhcHN0b25lX2ZyYW1lcl9maWxlcy9VVCBTUEVFRCBMQU5FYSB3IHN0cmV0Y2guZnJhbWVyL21vZHVsZXMvQ0FSTEFfQVBJLmNvZmZlZSIsIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiXSwic291cmNlc0NvbnRlbnQiOlsiIyBBZGQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIHlvdXIgcHJvamVjdCBpbiBGcmFtZXIgU3R1ZGlvLiBcbiMgbXlNb2R1bGUgPSByZXF1aXJlIFwibXlNb2R1bGVcIlxuIyBSZWZlcmVuY2UgdGhlIGNvbnRlbnRzIGJ5IG5hbWUsIGxpa2UgbXlNb2R1bGUubXlGdW5jdGlvbigpIG9yIG15TW9kdWxlLm15VmFyXG5cbmV4cG9ydHMubXlWYXIgPSBcIm15VmFyaWFibGVcIlxuXG5leHBvcnRzLm15RnVuY3Rpb24gPSAtPlxuXHRwcmludCBcIm15RnVuY3Rpb24gaXMgcnVubmluZ1wiXG5cbmV4cG9ydHMubXlBcnJheSA9IFsxLCAyLCAzXSIsIiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuIyBDcmVhdGVkIGJ5IEpvcmRhbiBSb2JlcnQgRG9ic29uIG9uIDE0IEF1Z3VzdCAyMDE1XG4jIFxuIyBVc2UgdG8gbm9ybWFsaXplIHNjcmVlbiAmIG9mZnNldCB4LHkgdmFsdWVzIGZyb20gY2xpY2sgb3IgdG91Y2ggZXZlbnRzLlxuI1xuIyBUbyBHZXQgU3RhcnRlZC4uLlxuI1xuIyAxLiBQbGFjZSB0aGlzIGZpbGUgaW4gRnJhbWVyIFN0dWRpbyBtb2R1bGVzIGRpcmVjdG9yeVxuI1xuIyAyLiBJbiB5b3VyIHByb2plY3QgaW5jbHVkZTpcbiMgICAgIHtQb2ludGVyfSA9IHJlcXVpcmUgXCJQb2ludGVyXCJcbiNcbiMgMy4gRm9yIHNjcmVlbiBjb29yZGluYXRlczogXG4jICAgICBidG4ub24gRXZlbnRzLkNsaWNrLCAoZXZlbnQsIGxheWVyKSAtPiBwcmludCBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXG4jIFxuIyA0LiBGb3IgbGF5ZXIgb2Zmc2V0IGNvb3JkaW5hdGVzOiBcbiMgICAgIGJ0bi5vbiBFdmVudHMuQ2xpY2ssIChldmVudCwgbGF5ZXIpIC0+IHByaW50IFBvaW50ZXIub2Zmc2V0KGV2ZW50LCBsYXllcilcbiNcbiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5jbGFzcyBleHBvcnRzLlBvaW50ZXJcblxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBQdWJsaWMgTWV0aG9kcyAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cblx0QHNjcmVlbiA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0c2NyZWVuQXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHRpZiBlLnggYW5kIGUueVxuXHRcdFx0IyBNb3VzZSBFdmVudFxuXHRcdFx0c2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCArPSBzY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55ICs9IHNjcmVlbkNvb3Jkcy55XG5cdFx0ZWxzZVxuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdHJldHVybiBlXG5cdFx0XHRcblx0QG9mZnNldCA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0b2Zmc2V0QXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHR1bmxlc3MgZS54PyBhbmQgZS55P1xuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdFx0dGFyZ2V0U2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCAtPSB0YXJnZXRTY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55IC09IHRhcmdldFNjcmVlbkNvb3Jkcy55XG5cdFx0cmV0dXJuIGVcblx0XG5cdCMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXHQjIFByaXZhdGUgSGVscGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0XG5cdG9mZnNldENvb3JkcyA9IChldikgIC0+IGUgPSBFdmVudHMudG91Y2hFdmVudCBldjsgcmV0dXJuIGNvb3JkcyBlLm9mZnNldFgsIGUub2Zmc2V0WVxuXHRjbGllbnRDb29yZHMgPSAoZXYpICAtPiBlID0gRXZlbnRzLnRvdWNoRXZlbnQgZXY7IHJldHVybiBjb29yZHMgZS5jbGllbnRYLCBlLmNsaWVudFlcblx0Y29vcmRzICAgICAgID0gKHgseSkgLT4gcmV0dXJuIHg6eCwgeTp5XG5cdFxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBFcnJvciBIYW5kbGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdFxuXHRzY3JlZW5Bcmd1bWVudEVycm9yID0gLT5cblx0XHRlcnJvciBudWxsXG5cdFx0Y29uc29sZS5lcnJvciBcIlwiXCJcblx0XHRcdFBvaW50ZXIuc2NyZWVuKCkgRXJyb3I6IFlvdSBtdXN0IHBhc3MgZXZlbnQgJiBsYXllciBhcmd1bWVudHMuIFxcblxuXHRcdFx0RXhhbXBsZTogbGF5ZXIub24gRXZlbnRzLlRvdWNoU3RhcnQsKGV2ZW50LGxheWVyKSAtPiBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXCJcIlwiXG5cdFx0XHRcblx0b2Zmc2V0QXJndW1lbnRFcnJvciA9IC0+XG5cdFx0ZXJyb3IgbnVsbFxuXHRcdGNvbnNvbGUuZXJyb3IgXCJcIlwiXG5cdFx0XHRQb2ludGVyLm9mZnNldCgpIEVycm9yOiBZb3UgbXVzdCBwYXNzIGV2ZW50ICYgbGF5ZXIgYXJndW1lbnRzLiBcXG5cblx0XHRcdEV4YW1wbGU6IGxheWVyLm9uIEV2ZW50cy5Ub3VjaFN0YXJ0LChldmVudCxsYXllcikgLT4gUG9pbnRlci5vZmZzZXQoZXZlbnQsIGxheWVyKVwiXCJcIiIsIklQX1BPUlQgPSAnaHR0cDovLzE3Mi4yNS4yLjE5OjgwODAnXG5ERUJVRyA9IHRydWVcblxucnVuX2FqYXggPSAobXNnKSAtPlxuICBpZiBERUJVR1xuICAgICMgLi4uXG4gICAgcmV0dXJuXG4gICQuYWpheFxuICAgIHVybDogSVBfUE9SVFxuICAgIGRhdGE6IG1zZ1xuICAgIG1ldGhvZDogJ1BPU1QnXG4gICAgY3Jvc3NPcmlnaW46IHRydWVcbiAgICBlcnJvcjogKGpxWEhSLCB0ZXh0U3RhdHVzLCBlcnJvclRocm93bikgLT5cbiAgICAgIGNvbnNvbGUubG9nKCdlcnJvcicpXG4gICAgICAkKCdib2R5JykuYXBwZW5kIFwiQUpBWCBFcnJvcjogI3t0ZXh0U3RhdHVzfVwiXG4gICAgc3VjY2VzczogKGRhdGEsIHRleHRTdGF0dXMsIGpxWEhSKSAtPlxuICAgICAgY29uc29sZS5sb2coJ3llcycpXG4gICAgICBjb25zb2xlLmxvZyhkYXRhKVxuICAgICAgJCgnYm9keScpLmFwcGVuZCBcIlN1Y2Nlc3NmdWwgQUpBWCBjYWxsOiAje2RhdGF9XCIgIFxuXG5leHBvcnRzLmJlZ2luX3NlcnZlciA9IC0+XG4gIHJ1bl9hamF4KCdzdGFydHNlcnZlcicpXG5cbmV4cG9ydHMuc3BlZWRfdXAgPSAtPlxuICBydW5fYWpheCgnZm9yd2FyZCcpXG5cbmV4cG9ydHMuc3RvcF9zcGVlZGluZ191cCA9IC0+XG4gIHJ1bl9hamF4KCdmb3J3YXJkX3N0b3AnKVxuXG5leHBvcnRzLnNsb3dfZG93biA9IC0+XG4gIHJ1bl9hamF4KCdiYWNrd2FyZCcpXG5cbmV4cG9ydHMuc3RvcF9zbG93aW5nX2Rvd24gPSAtPlxuICBydW5fYWpheCgnYmFja3dhcmRfc3RvcCcpXG5cbmV4cG9ydHMubW92ZV9sZWZ0ID0gLT5cbiAgcnVuX2FqYXgoJ2xlZnQnKVxuXG5leHBvcnRzLnN0b3BfbW92aW5nX2xlZnQgPSAtPlxuICBydW5fYWpheCgnbGVmdF9zdG9wJylcblxuZXhwb3J0cy5tb3ZlX3JpZ2h0ID0gLT5cbiAgcnVuX2FqYXgoJ3JpZ2h0JylcblxuZXhwb3J0cy5zdG9wX21vdmluZ19yaWdodCA9IC0+XG4gIHJ1bl9hamF4KCdyaWdodF9zdG9wJylcblxuZXhwb3J0cy5oYXJkX3N0b3AgPSAtPlxuICBydW5fYWpheCgnc3RvcCcpXG5cbmV4cG9ydHMucmVtb3ZlX2FsbF9jb21tYW5kcyA9IC0+XG4gIHJ1bl9hamF4KCdjbGVhcicpXG5cbmV4cG9ydHMudG9nZ2xlX2F1dG9waWxvdCA9IC0+XG4gIHJ1bl9hamF4KCdlbmFibGVfYXAnKVxuIiwiKGZ1bmN0aW9uIGUodCxuLHIpe2Z1bmN0aW9uIHMobyx1KXtpZighbltvXSl7aWYoIXRbb10pe3ZhciBhPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7aWYoIXUmJmEpcmV0dXJuIGEobywhMCk7aWYoaSlyZXR1cm4gaShvLCEwKTt2YXIgZj1uZXcgRXJyb3IoXCJDYW5ub3QgZmluZCBtb2R1bGUgJ1wiK28rXCInXCIpO3Rocm93IGYuY29kZT1cIk1PRFVMRV9OT1RfRk9VTkRcIixmfXZhciBsPW5bb109e2V4cG9ydHM6e319O3Rbb11bMF0uY2FsbChsLmV4cG9ydHMsZnVuY3Rpb24oZSl7dmFyIG49dFtvXVsxXVtlXTtyZXR1cm4gcyhuP246ZSl9LGwsbC5leHBvcnRzLGUsdCxuLHIpfXJldHVybiBuW29dLmV4cG9ydHN9dmFyIGk9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtmb3IodmFyIG89MDtvPHIubGVuZ3RoO28rKylzKHJbb10pO3JldHVybiBzfSkiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFHQUE7QURBQSxJQUFBOztBQUFBLE9BQUEsR0FBVTs7QUFDVixLQUFBLEdBQVE7O0FBRVIsUUFBQSxHQUFXLFNBQUMsR0FBRDtFQUNULElBQUcsS0FBSDtBQUVFLFdBRkY7O1NBR0EsQ0FBQyxDQUFDLElBQUYsQ0FDRTtJQUFBLEdBQUEsRUFBSyxPQUFMO0lBQ0EsSUFBQSxFQUFNLEdBRE47SUFFQSxNQUFBLEVBQVEsTUFGUjtJQUdBLFdBQUEsRUFBYSxJQUhiO0lBSUEsS0FBQSxFQUFPLFNBQUMsS0FBRCxFQUFRLFVBQVIsRUFBb0IsV0FBcEI7TUFDTCxPQUFPLENBQUMsR0FBUixDQUFZLE9BQVo7YUFDQSxDQUFBLENBQUUsTUFBRixDQUFTLENBQUMsTUFBVixDQUFpQixjQUFBLEdBQWUsVUFBaEM7SUFGSyxDQUpQO0lBT0EsT0FBQSxFQUFTLFNBQUMsSUFBRCxF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
