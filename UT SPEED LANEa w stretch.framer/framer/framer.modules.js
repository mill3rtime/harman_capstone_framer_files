require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"CARLA_API":[function(require,module,exports){
var DEBUG, IP_PORT, run_ajax;

IP_PORT = 'http://172.25.2.19:8080';

DEBUG = false;

run_ajax = function(msg) {
  console.log(msg);
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
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uL21vZHVsZXMvbXlNb2R1bGUuY29mZmVlIiwiLi4vbW9kdWxlcy9Qb2ludGVyLmNvZmZlZSIsIi4uL21vZHVsZXMvQ0FSTEFfQVBJLmNvZmZlZSIsIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiXSwic291cmNlc0NvbnRlbnQiOlsiIyBBZGQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIHlvdXIgcHJvamVjdCBpbiBGcmFtZXIgU3R1ZGlvLiBcbiMgbXlNb2R1bGUgPSByZXF1aXJlIFwibXlNb2R1bGVcIlxuIyBSZWZlcmVuY2UgdGhlIGNvbnRlbnRzIGJ5IG5hbWUsIGxpa2UgbXlNb2R1bGUubXlGdW5jdGlvbigpIG9yIG15TW9kdWxlLm15VmFyXG5cbmV4cG9ydHMubXlWYXIgPSBcIm15VmFyaWFibGVcIlxuXG5leHBvcnRzLm15RnVuY3Rpb24gPSAtPlxuXHRwcmludCBcIm15RnVuY3Rpb24gaXMgcnVubmluZ1wiXG5cbmV4cG9ydHMubXlBcnJheSA9IFsxLCAyLCAzXSIsIiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuIyBDcmVhdGVkIGJ5IEpvcmRhbiBSb2JlcnQgRG9ic29uIG9uIDE0IEF1Z3VzdCAyMDE1XG4jIFxuIyBVc2UgdG8gbm9ybWFsaXplIHNjcmVlbiAmIG9mZnNldCB4LHkgdmFsdWVzIGZyb20gY2xpY2sgb3IgdG91Y2ggZXZlbnRzLlxuI1xuIyBUbyBHZXQgU3RhcnRlZC4uLlxuI1xuIyAxLiBQbGFjZSB0aGlzIGZpbGUgaW4gRnJhbWVyIFN0dWRpbyBtb2R1bGVzIGRpcmVjdG9yeVxuI1xuIyAyLiBJbiB5b3VyIHByb2plY3QgaW5jbHVkZTpcbiMgICAgIHtQb2ludGVyfSA9IHJlcXVpcmUgXCJQb2ludGVyXCJcbiNcbiMgMy4gRm9yIHNjcmVlbiBjb29yZGluYXRlczogXG4jICAgICBidG4ub24gRXZlbnRzLkNsaWNrLCAoZXZlbnQsIGxheWVyKSAtPiBwcmludCBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXG4jIFxuIyA0LiBGb3IgbGF5ZXIgb2Zmc2V0IGNvb3JkaW5hdGVzOiBcbiMgICAgIGJ0bi5vbiBFdmVudHMuQ2xpY2ssIChldmVudCwgbGF5ZXIpIC0+IHByaW50IFBvaW50ZXIub2Zmc2V0KGV2ZW50LCBsYXllcilcbiNcbiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5jbGFzcyBleHBvcnRzLlBvaW50ZXJcblxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBQdWJsaWMgTWV0aG9kcyAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cblx0QHNjcmVlbiA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0c2NyZWVuQXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHRpZiBlLnggYW5kIGUueVxuXHRcdFx0IyBNb3VzZSBFdmVudFxuXHRcdFx0c2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCArPSBzY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55ICs9IHNjcmVlbkNvb3Jkcy55XG5cdFx0ZWxzZVxuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdHJldHVybiBlXG5cdFx0XHRcblx0QG9mZnNldCA9IChldmVudCwgbGF5ZXIpIC0+XG5cdFx0b2Zmc2V0QXJndW1lbnRFcnJvcigpIHVubGVzcyBldmVudD8gYW5kIGxheWVyP1xuXHRcdGUgPSBvZmZzZXRDb29yZHMgZXZlbnRcblx0XHR1bmxlc3MgZS54PyBhbmQgZS55P1xuXHRcdFx0IyBUb3VjaCBFdmVudFxuXHRcdFx0ZSA9IGNsaWVudENvb3JkcyBldmVudFxuXHRcdFx0dGFyZ2V0U2NyZWVuQ29vcmRzID0gbGF5ZXIuc2NyZWVuRnJhbWVcblx0XHRcdGUueCAtPSB0YXJnZXRTY3JlZW5Db29yZHMueFxuXHRcdFx0ZS55IC09IHRhcmdldFNjcmVlbkNvb3Jkcy55XG5cdFx0cmV0dXJuIGVcblx0XG5cdCMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXHQjIFByaXZhdGUgSGVscGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0XG5cdG9mZnNldENvb3JkcyA9IChldikgIC0+IGUgPSBFdmVudHMudG91Y2hFdmVudCBldjsgcmV0dXJuIGNvb3JkcyBlLm9mZnNldFgsIGUub2Zmc2V0WVxuXHRjbGllbnRDb29yZHMgPSAoZXYpICAtPiBlID0gRXZlbnRzLnRvdWNoRXZlbnQgZXY7IHJldHVybiBjb29yZHMgZS5jbGllbnRYLCBlLmNsaWVudFlcblx0Y29vcmRzICAgICAgID0gKHgseSkgLT4gcmV0dXJuIHg6eCwgeTp5XG5cdFxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBFcnJvciBIYW5kbGVyIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdFxuXHRzY3JlZW5Bcmd1bWVudEVycm9yID0gLT5cblx0XHRlcnJvciBudWxsXG5cdFx0Y29uc29sZS5lcnJvciBcIlwiXCJcblx0XHRcdFBvaW50ZXIuc2NyZWVuKCkgRXJyb3I6IFlvdSBtdXN0IHBhc3MgZXZlbnQgJiBsYXllciBhcmd1bWVudHMuIFxcblxuXHRcdFx0RXhhbXBsZTogbGF5ZXIub24gRXZlbnRzLlRvdWNoU3RhcnQsKGV2ZW50LGxheWVyKSAtPiBQb2ludGVyLnNjcmVlbihldmVudCwgbGF5ZXIpXCJcIlwiXG5cdFx0XHRcblx0b2Zmc2V0QXJndW1lbnRFcnJvciA9IC0+XG5cdFx0ZXJyb3IgbnVsbFxuXHRcdGNvbnNvbGUuZXJyb3IgXCJcIlwiXG5cdFx0XHRQb2ludGVyLm9mZnNldCgpIEVycm9yOiBZb3UgbXVzdCBwYXNzIGV2ZW50ICYgbGF5ZXIgYXJndW1lbnRzLiBcXG5cblx0XHRcdEV4YW1wbGU6IGxheWVyLm9uIEV2ZW50cy5Ub3VjaFN0YXJ0LChldmVudCxsYXllcikgLT4gUG9pbnRlci5vZmZzZXQoZXZlbnQsIGxheWVyKVwiXCJcIiIsIiMgPT09IENBUkxBIE5ldHdvcmtpbmcgQVBJID09PVxuXG4jIEFuIGludGVyZmFjZSB0byBpbnRlcmFjdCB3aXRoIHRoZSBDQVJMQSBEcml2aW5nIFNpbXVsYXRvciBiYXNlZCBvbiB0aGUgTUhDSSBQcm90b2NvbFxuXG4jIFRoZSBiZWxvdyBJUC9QT1JUIHdpbGwgdmFyeVxuSVBfUE9SVCA9ICdodHRwOi8vMTcyLjI1LjIuMTk6ODA4MCdcbkRFQlVHID0gZmFsc2VcblxuIyA9PT0gcnVuX2FqYXggPT09XG5ydW5fYWpheCA9IChtc2cpIC0+XG4gICMgQSBnZW5lcmljIEFKQVggd3JhcHBlciB0byBwZXJmb3JtIFBPU1QgcmVxdWVzdHMgdG8gdGhlIFB5dGhvbiBIVFRQIFNlcnZlclxuICBjb25zb2xlLmxvZyhtc2cpXG4gIGlmIERFQlVHXG4gICAgIyAuLi5cbiAgICByZXR1cm5cbiAgIyBQZXJmb3JtIGFuIEFKQVggcG9zdCByZXF1ZXN0IHdpdGggb3VyIG1lc3NhZ2VcbiAgJC5hamF4XG4gICAgdXJsOiBJUF9QT1JUXG4gICAgZGF0YTogbXNnXG4gICAgbWV0aG9kOiAnUE9TVCdcbiAgICBjcm9zc09yaWdpbjogdHJ1ZVxuICAgIGVycm9yOiAoanFYSFIsIHRleHRTdGF0dXMsIGVycm9yVGhyb3duKSAtPlxuICAgICAgY29uc29sZS5sb2coJ2Vycm9yJylcbiAgICAgICQoJ2JvZHknKS5hcHBlbmQgXCJBSkFYIEVycm9yOiAje3RleHRTdGF0dXN9XCJcbiAgICBzdWNjZXNzOiAoZGF0YSwgdGV4dFN0YXR1cywganFYSFIpIC0+XG4gICAgICBjb25zb2xlLmxvZygneWVzJylcbiAgICAgIGNvbnNvbGUubG9nKGRhdGEpXG4gICAgICAkKCdib2R5JykuYXBwZW5kIFwiU3VjY2Vzc2Z1bCBBSkFYIGNhbGw6ICN7ZGF0YX1cIiAgXG5cbiMgQmVnaW4gdGhlIHNlcnZlciB3aXRoIHRoaXMgY29tbWFuZFxuZXhwb3J0cy5iZWdpbl9zZXJ2ZXIgPSAtPlxuICBydW5fYWpheCgnc3RhcnRzZXJ2ZXInKVxuXG4jIFNwZWVkIHVwXG5leHBvcnRzLnNwZWVkX3VwID0gLT5cbiAgcnVuX2FqYXgoJ2ZvcndhcmQnKVxuXG4jIFN0b3Agc3BlZWRpbmcgdXBcbmV4cG9ydHMuc3RvcF9zcGVlZGluZ191cCA9IC0+XG4gIHJ1bl9hamF4KCdmb3J3YXJkX3N0b3AnKVxuXG4jIFNsb3cgZG93blxuZXhwb3J0cy5zbG93X2Rvd24gPSAtPlxuICBydW5fYWpheCgnYmFja3dhcmQnKVxuXG4jIFN0b3Agc2xvd2luZyBkb3duXG5leHBvcnRzLnN0b3Bfc2xvd2luZ19kb3duID0gLT5cbiAgcnVuX2FqYXgoJ2JhY2t3YXJkX3N0b3AnKVxuXG4jIEFkanVzdCBsZWZ0IGluIGxhbmVcbmV4cG9ydHMubW92ZV9sZWZ0ID0gLT5cbiAgcnVuX2FqYXgoJ2xlZnQnKVxuXG4jIFN0b3AgYWRqdXN0aW5nXG5leHBvcnRzLnN0b3BfbW92aW5nX2xlZnQgPSAtPlxuICBydW5fYWpheCgnbGVmdF9zdG9wJylcblxuIyBBZGp1c3QgcmlnaHQgaW4gbGFuZVxuZXhwb3J0cy5tb3ZlX3JpZ2h0ID0gLT5cbiAgcnVuX2FqYXgoJ3JpZ2h0JylcblxuIyBTdG9wIGFkanVzdGluZ1xuZXhwb3J0cy5zdG9wX21vdmluZ19yaWdodCA9IC0+XG4gIHJ1bl9hamF4KCdyaWdodF9zdG9wJylcblxuIyBFbWVyZ2VuY3kgc3RvcFxuZXhwb3J0cy5oYXJkX3N0b3AgPSAtPlxuICBydW5fYWpheCgnc3RvcCcpXG5cbiMgQ2xlYXIgYWxsIGNvbW1hbmRzIHNlbnQgdG8gdGhlIGNhclxuZXhwb3J0cy5yZW1vdmVfYWxsX2NvbW1hbmRzID0gLT5cbiAgcnVuX2FqYXgoJ2NsZWFyJylcblxuZXhwb3J0cy50b2dnbGVfYXV0b3BpbG90ID0gLT5cbiAgcnVuX2FqYXgoJ2VuYWJsZV9hcCcpXG4iLCIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUdBQTtBREtBLElBQUE7O0FBQUEsT0FBQSxHQUFVOztBQUNWLEtBQUEsR0FBUTs7QUFHUixRQUFBLEdBQVcsU0FBQyxHQUFEO0VBRVQsT0FBTyxDQUFDLEdBQVIsQ0FBWSxHQUFaO0VBQ0EsSUFBRyxLQUFIO0FBRUUsV0FGRjs7U0FJQSxD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
