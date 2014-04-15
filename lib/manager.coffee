stream = require 'stream'

class Manager extends stream.Readable

  ###
    @opts = 
      queue 
  ###
  constructor: (@opts)->

    super

  close: ()->


  # private stream methods
  _read: (size)->

  _write: ()->


module.exports = Manager
