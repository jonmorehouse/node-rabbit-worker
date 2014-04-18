stream = require 'stream'

class TaskHandler extends stream.Writable

  constructor: ->

    super 
      objectMode: true
    @tasks = {}

  _write: (data, enc, cb)->

    if typeof data == "object"
      p "OBJECT"
    else if typeof data == "string"
      p "STRING"
    else   
      return cb new Error "Invalid parameter"

    cb?()


module.exports = TaskHandler
