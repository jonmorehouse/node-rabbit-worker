path = require 'path'
amqp = require 'amqp'
fs = require 'fs'

# helper module-wide functions
baseDirectory = path.resolve path.join __dirname, ".."

# modify global namespace
global.conn = null
global.p = console.log
global.libRequire = (_path)->
  return require path.join baseDirectory, "lib", _path

exports.setUp = (cb)->

  if not global.conn? 
    conn = amqp.createConnection {host: "localhost", port: 5672}
    conn.on "ready", ->
      global.conn = conn
      cb?()
    conn.on "error", (err)->
      cb err if err
  else
    cb?()

exports.tearDown = (cb)->

  # remove all of our test handler files
  fs.unlink path.join baseDirectory, filename for filename in [".graceful", ".restart", ".kill"]
  if global.conn?
    global.conn.disconnect()
  cb?()



