'use strict';
const express = require('express');
const SocketServer = require('ws').Server;
const path = require('path');
const PORT = 3000;
const INDEX = path.join(__dirname, 'index.html');
//init Express
var app = express();
var server = app.listen(PORT, function () {
    console.log('node.js static server listening on port: ' + PORT +  ", with websockets listener")
})

const wss = new SocketServer({ server });
//init Websocket ws and handle incoming connect requests
wss.on('connection', function connection(ws) {
    console.log("connection ...");
    //General GET parser
    app.get('/:cmd', function (req, res){
      let command = req.params.cmd
      if (command != 'favicon.ico') {
        console.log(command);
        res.send('confirmed, sending message ' + command + ' to the second screen.');
        ws.send(command);        
      }
    })
});
