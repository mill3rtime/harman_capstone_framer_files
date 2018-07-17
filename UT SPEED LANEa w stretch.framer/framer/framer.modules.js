require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"CARLA_API":[function(require,module,exports){
var DEBUG, IP_PORT, run_ajax;

IP_PORT = 'http://172.25.2.19:8080';

DEBUG = false;

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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uL21vZHVsZXMvbXlNb2R1bGUuY29mZmVlIiwiLi4vbW9kdWxlcy9Qb2ludGVyLmNvZmZlZSIsIi4uL21vZHVsZXMvQ0FSTEFfQVBJLmNvZmZlZSIsIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiXSwic291cmNlc0NvbnRlbnQiOlsiIyBBZGQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIHlvdXIgcHJvamVjdCBpbiBGcmFtZXIgU3R1ZGlvLiBcbiMgbXlNb2R1bGUgPSByZXF1aXJlIFwibXlNb2R1bGVcIlxuIyBSZWZlcmVuY2UgdGhlIGNvbnRlbnRzIGJ5IG5hbWUsIGxpa2UgbXlNb2R1bGUubXlGdW5jdGlvbigpIG9yIG15TW9kdWxlLm15VmFyXG5cbmV4cG9ydHMubXlWYXIgPSBcIm15VmFyaWFibGVcIlxuXG5leHBvcnRzLm15RnVuY3Rpb24gPSAtPlxuXHRwcmludCBcIm15RnVuY3Rpb24gaXMgcnVubmluZ1wiXG5cbmV4cG9ydHMubXlBcnJheSA9IFsxLCAyLCAzXSIsIiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuIyBDcmVhdGVkIGJ5IEpvcmRhbiBSb2JlcnQgRG9ic29uIG9uIDE0IEF1Z3VzdCAyMDE1XG4jIFxuIyBVc2UgdG8gbm9ybWFsaXplIHNjcmVlbiAmIG9mZnNldCB4LHkgdmFsdWVzIGZyb20gY2xpY2sgb3IgdG91Y2ggZXZlbnRzLlxuI1xuIyBUbyBHZXQgU3RhcnRlZC4uLlxuI1xuIyAxLiBQbGFjZSB0aGlzIGZpbGUgaW4gRnJhbWVyIFN0dWRpbyBtb2R1bGVzIGRpcmVjdG9yeVxuI1xuIyAyLiBJbiB5b3VyIHByb2plY3QgaW5jbHVkZTpcbiMgICAgIHtQb2ludGVyfSA9IHJlcXVpcmUgXCJQb2ludGVyXCJcbiNcbiMgMy4gRm9yIHNjcmVlbiBjb29yZGluYXRlczogXG4jICAgICBidG4ub24gRXZlbnRzLkNsaWNrLCAoZXZlbnQsIGxheWVyKSAtPiBwcmludCBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXG4jIFxuIyA0LiBGb3IgbGF5ZXIgb2Zmc2V0IGNvb3JkaW5hdGVzOiBcbiMgICAgIGJ0bi5vbiBFdmVudHMuQ2xpY2ssIChldmVudCwgbGF5ZXIpIC0+IHByaW50IFBvaW50ZXIub2Zmc2V0KGV2ZW50LCBsYXllcilcbiNcbiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5jbGFzcyBleHBvcnRzLlBvaW50ZXJcblxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBQdWJsaWMgTWV0aG9kcyAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cblx0QHNjcmVlbiA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0c2NyZWVuQXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHRpZiBlLnggYW5kIGUueVxuXHRcdFx0IyBNb3VzZSBFdmVudFxuXHRcdFx0c2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCArPSBzY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55ICs9IHNjcmVlbkNvb3Jkcy55XG5cdFx0ZWxzZVxuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdHJldHVybiBlXG5cdFx0XHRcblx0QG9mZnNldCA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0b2Zmc2V0QXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHR1bmxlc3MgZS54PyBhbmQgZS55P1xuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdFx0dGFyZ2V0U2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCAtPSB0YXJnZXRTY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55IC09IHRhcmdldFNjcmVlbkNvb3Jkcy55XG5cdFx0cmV0dXJuIGVcblx0XG5cdCMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXHQjIFByaXZhdGUgSGVscGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0XG5cdG9mZnNldENvb3JkcyA9IChldikgIC0+IGUgPSBFdmVudHMudG91Y2hFdmVudCBldjsgcmV0dXJuIGNvb3JkcyBlLm9mZnNldFgsIGUub2Zmc2V0WVxuXHRjbGllbnRDb29yZHMgPSAoZXYpICAtPiBlID0gRXZlbnRzLnRvdWNoRXZlbnQgZXY7IHJldHVybiBjb29yZHMgZS5jbGllbnRYLCBlLmNsaWVudFlcblx0Y29vcmRzICAgICAgID0gKHgseSkgLT4gcmV0dXJuIHg6eCwgeTp5XG5cdFxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBFcnJvciBIYW5kbGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdFxuXHRzY3JlZW5Bcmd1bWVudEVycm9yID0gLT5cblx0XHRlcnJvciBudWxsXG5cdFx0Y29uc29sZS5lcnJvciBcIlwiXCJcblx0XHRcdFBvaW50ZXIuc2NyZWVuKCkgRXJyb3I6IFlvdSBtdXN0IHBhc3MgZXZlbnQgJiBsYXllciBhcmd1bWVudHMuIFxcblxuXHRcdFx0RXhhbXBsZTogbGF5ZXIub24gRXZlbnRzLlRvdWNoU3RhcnQsKGV2ZW50LGxheWVyKSAtPiBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXCJcIlwiXG5cdFx0XHRcblx0b2Zmc2V0QXJndW1lbnRFcnJvciA9IC0+XG5cdFx0ZXJyb3IgbnVsbFxuXHRcdGNvbnNvbGUuZXJyb3IgXCJcIlwiXG5cdFx0XHRQb2ludGVyLm9mZnNldCgpIEVycm9yOiBZb3UgbXVzdCBwYXNzIGV2ZW50ICYgbGF5ZXIgYXJndW1lbnRzLiBcXG5cblx0XHRcdEV4YW1wbGU6IGxheWVyLm9uIEV2ZW50cy5Ub3VjaFN0YXJ0LChldmVudCxsYXllcikgLT4gUG9pbnRlci5vZmZzZXQoZXZlbnQsIGxheWVyKVwiXCJcIiIsIklQX1BPUlQgPSAnaHR0cDovLzE3Mi4yNS4yLjE5OjgwODAnXG5ERUJVRyA9IGZhbHNlXG5cbnJ1bl9hamF4ID0gKG1zZykgLT5cbiAgaWYgREVCVUdcbiAgICAjIC4uLlxuICAgIHJldHVyblxuICAkLmFqYXhcbiAgICB1cmw6IElQX1BPUlRcbiAgICBkYXRhOiBtc2dcbiAgICBtZXRob2Q6ICdQT1NUJ1xuICAgIGNyb3NzT3JpZ2luOiB0cnVlXG4gICAgZXJyb3I6IChqcVhIUiwgdGV4dFN0YXR1cywgZXJyb3JUaHJvd24pIC0+XG4gICAgICBjb25zb2xlLmxvZygnZXJyb3InKVxuICAgICAgJCgnYm9keScpLmFwcGVuZCBcIkFKQVggRXJyb3I6ICN7dGV4dFN0YXR1c31cIlxuICAgIHN1Y2Nlc3M6IChkYXRhLCB0ZXh0U3RhdHVzLCBqcVhIUikgLT5cbiAgICAgIGNvbnNvbGUubG9nKCd5ZXMnKVxuICAgICAgY29uc29sZS5sb2coZGF0YSlcbiAgICAgICQoJ2JvZHknKS5hcHBlbmQgXCJTdWNjZXNzZnVsIEFKQVggY2FsbDogI3tkYXRhfVwiICBcblxuZXhwb3J0cy5iZWdpbl9zZXJ2ZXIgPSAtPlxuICBydW5fYWpheCgnc3RhcnRzZXJ2ZXInKVxuXG5leHBvcnRzLnNwZWVkX3VwID0gLT5cbiAgcnVuX2FqYXgoJ2ZvcndhcmQnKVxuXG5leHBvcnRzLnN0b3Bfc3BlZWRpbmdfdXAgPSAtPlxuICBydW5fYWpheCgnZm9yd2FyZF9zdG9wJylcblxuZXhwb3J0cy5zbG93X2Rvd24gPSAtPlxuICBydW5fYWpheCgnYmFja3dhcmQnKVxuXG5leHBvcnRzLnN0b3Bfc2xvd2luZ19kb3duID0gLT5cbiAgcnVuX2FqYXgoJ2JhY2t3YXJkX3N0b3AnKVxuXG5leHBvcnRzLm1vdmVfbGVmdCA9IC0+XG4gIHJ1bl9hamF4KCdsZWZ0JylcblxuZXhwb3J0cy5zdG9wX21vdmluZ19sZWZ0ID0gLT5cbiAgcnVuX2FqYXgoJ2xlZnRfc3RvcCcpXG5cbmV4cG9ydHMubW92ZV9yaWdodCA9IC0+XG4gIHJ1bl9hamF4KCdyaWdodCcpXG5cbmV4cG9ydHMuc3RvcF9tb3ZpbmdfcmlnaHQgPSAtPlxuICBydW5fYWpheCgncmlnaHRfc3RvcCcpXG5cbmV4cG9ydHMuaGFyZF9zdG9wID0gLT5cbiAgcnVuX2FqYXgoJ3N0b3AnKVxuXG5leHBvcnRzLnJlbW92ZV9hbGxfY29tbWFuZHMgPSAtPlxuICBydW5fYWpheCgnY2xlYXInKVxuXG5leHBvcnRzLnRvZ2dsZV9hdXRvcGlsb3QgPSAtPlxuICBydW5fYWpheCgnZW5hYmxlX2FwJylcbiIsIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dmFyIGY9bmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKTt0aHJvdyBmLmNvZGU9XCJNT0RVTEVfTk9UX0ZPVU5EXCIsZn12YXIgbD1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwobC5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxsLGwuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBR0FBO0FEQUEsSUFBQTs7QUFBQSxPQUFBLEdBQVU7O0FBQ1YsS0FBQSxHQUFROztBQUVSLFFBQUEsR0FBVyxTQUFDLEdBQUQ7RUFDVCxJQUFHLEtBQUg7QUFFRSxXQUZGOztTQUdBLENBQUMsQ0FBQyxJQUFGLENBQ0U7SUFBQSxHQUFBLEVBQUssT0FBTDtJQUNBLElBQUEsRUFBTSxHQUROO0lBRUEsTUFBQSxFQUFRLE1BRlI7SUFHQSxXQUFBLEVBQWEsSUFIYjtJQUlBLEtBQUEsRUFBTyxTQUFDLEtBQUQsRUFBUSxVQUFSLEVBQW9CLFdBQXBCO01BQ0wsT0FBTyxDQUFDLEdBQVIsQ0FBWSxPQUFaO2FBQ0EsQ0FBQSxDQUFFLE1BQUYsQ0FBUyxDQUFDLE1BQVYsQ0FBaUIsY0FBQSxHQUFlLFVBQWhDO0lBRkssQ0FKUDtJQU9BLE9BQUEsRUFBUyxTQUFDLElBQUQsRUFBTyxVQUFQLEVBQW1CLEtBQW5CO01BQ1AsT0FBTyxDQUFDLEdBQVIsQ0FBWSxLQUFaO01BQ0EsT0FBTyxDQUFDLEdBQVIsQ0FBWSxJQUFaO2FBQ0EsQ0FBQSxDQUFFLE1BQUYsQ0FBUyxDQUFDLE1BQVYsQ0FBaUIsd0JBQUEsR0FBeUIsSUFBMUM7SUFITyxDQVBUO0dBREY7QUFKUzs7QUFpQlgsT0FBTyxDQUFDLFlBQVIsR0FBdUIsU0FBQTtTQUNyQixRQUFBLENBQVMsYUFBVDtBQURxQjs7QUFHdkIsT0FBTyxDQUFDLFFBQVIsR0FBbUIsU0FBQTtTQUNqQixRQUFBLENBQVMsU0FBVDtBQURpQjs7QUFHbkIsT0FBTyxDQUFDLGdCQUFSLEdBQTJCLFNBQUE7U0FDekIsUUFBQSxDQUFT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
