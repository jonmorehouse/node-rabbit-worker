path = require 'path'
amqp = require 'amqp'
async = require 'async'
fs = require 'fs'
stream = require 'stream'

# print out all call stack errors - this helps a ton!
process.on 'uncaughtException', (err)->
  console.error err.stack

# initialize global variables for helping out with tests
global.baseDirectory = path.resolve path.join __dirname, ".."
global.conn = null
global.p = console.log
global.libRequire = (_path)->
  return require path.join baseDirectory, "lib", _path

setUpFunctions = 
  stream: (cb)->
    global.testStream = new stream.Duplex()
    cb?()
  amqp: (cb)->
    if not global.conn? 
      conn = amqp.createConnection {host: "localhost", port: 5672}
      conn.on "ready", ->
        global.conn = conn
        cb?()
      conn.on "error", (err)->
        cb? err if err
    else 
      cb?()
  exchange: (cb)->
    global.exchange = conn.exchange "test-exchange", {confirm: true}
    exchange.on "error", (err)->
      cb? err if err
    cb?()
  queue: (cb)->
    conn.queue "test-queue", (q)->
      global.queue = q
      q.bind exchange, "*"
      cb?()

tearDownFunctions = 
  stream: (cb)->
    testStream.end()
    delete global.testStream
    cb?()
  queue: (cb)->
    if global.queue?
      queue.unbind exchange.name, "*"
      queue.destroy()
      delete global.queue
    cb?()
  exchange: (cb)->
    if global.exchange?
      exchange.destroy()
      delete global.exchange
    cb?()
  amqp: (cb)->
    if global.conn?
      global.conn.disconnect()
      delete global.conn
    cb?()

exports.setUp = (cb)->
  async.waterfall (_function for key, _function of setUpFunctions), (err)->
    p err if err?
    cb?() 

exports.tearDown = (cb)->
  async.waterfall (_function for key, _function of tearDownFunctions), (err)->
    p err if err?
    cb?()

exports.utilities = 
  publish: (msg, cb)->
    if not cb? 
      cb = msg
      msg = {key: "value"}
    # this assumes that the server is in confirm mode ...
    exchange.publish queue.name, msg, {}, (err)->
      return cb err if err
      cb?()

