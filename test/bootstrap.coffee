path = require 'path'
amqp = require 'amqp'
async = require 'async'
fs = require 'fs'

# initialize global variables for test directory 
global.baseDirectory = path.resolve path.join __dirname, ".."
global.conn = null
global.p = console.log
global.libRequire = (_path)->
  return require path.join baseDirectory, "lib", _path

setUpFunctions = 
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

tearDownFunctions = 
  amqp: (cb)->
    if global.conn?
      global.conn.disconnect()
      delete global.conn
    cb?()

exports.setUp = (cb)->
  async.waterfall (_function for key, _function of setUpFunctions), (err)->
    cb?()

exports.tearDown = (cb)->
  async.waterfall (_function for key, _function of tearDownFunctions), (err)->
    cb?()


