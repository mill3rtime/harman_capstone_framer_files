/*
server.js
A node/express HTTP server that forwards GET request parameters through to
applications connected via WebSockets (ws)
Jordan Stapinski - MHCI Harman Capstone CMU 2018
*/

'use strict';
const express = require('express');
const SocketServer = require('ws').Server;
const PORT = 3000;
// init Express server at localhost:3000
var app = express();
var server = app.listen(PORT, function () {
    console.log('node.js static server listening on port: ' + PORT +  ", with websockets listener")
})

const wss = new SocketServer({ server });
// init Websocket ws and handle incoming connect requests
wss.on('connection', function connection(ws) {
    console.log('New connection');
    // General GET parser for HTTP Server (only once socket connection established)
    app.get('/:cmd', function (req, res){
      let command = req.params.cmd;
      // Ignore icons being pushed through the HTTP Server
      if (command != 'favicon.ico') {
        console.log(command);
        res.send('confirmed, sending message ' + command + ' to the second screen.');
        ws.send(command);        
      }
    })
});
