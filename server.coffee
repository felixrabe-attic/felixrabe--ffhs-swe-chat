#!/usr/bin/env coffee

coffee   = require 'coffee-script'
express  = require 'express'
fs       = require 'fs'
http     = require 'http'
socketio = require 'socket.io'

app = express()
server = http.createServer app
io = socketio.listen server

class Logic
  constructor: ->
    @connections = []
    @messages = [
      'first'
      'second'
      'third'
    ]

  join: (socket) ->
    @connections.push socket
    socket.emit 'msg', msg for msg in @messages
    socket.on 'msg', (msg) =>
      @emitToAll msg
    socket.on 'disconnect', ->
      @connections.splice @connections.indexOf(socket), 1

  emitToAll: (msg) ->
    @messages.push msg
    socket.emit 'msg', msg for socket in @connections

logic = new Logic()

express.response.js = (file) ->
  @setHeader 'Content-Type', 'application/x-javascript'
  @send file

app.use express.static __dirname + '/public'

mainJs = coffee.compile fs.readFileSync(__dirname + '/main.coffee', 'utf-8')

app.get '/main.js', (req, res) -> res.js mainJs

io.sockets.on 'connection', (socket) ->
  logic.join socket

server.listen 3000
