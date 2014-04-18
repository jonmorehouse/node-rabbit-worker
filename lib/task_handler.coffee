stream = require 'stream'

class TaskHandler extends stream.Writable

  constructor: (@logger, @error)->

    super 
      objectMode: true
    @tasks = {}

  _write: (data, enc, cb)->

    cb "TEST"

    #if typeof data == "object"
      #p "OBJECT"
    #else if typeof data == "string"
      #p "STRING"
    #else   
      #return cb "test ERROR"

    #cb?()


module.exports = TaskHandler
