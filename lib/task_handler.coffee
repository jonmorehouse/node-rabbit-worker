stream = require 'stream'

class TaskHandler extends stream.Writable

  constructor: ->

    super 
      objectMode: true
    @tasks = {}

  _write: (data, enc, cb)->

    if typeof data == "object"
      @_handleTask data, cb
    else if typeof data == "string"
      @_addTask data, cb
    return cb new Error "Invalid parameter"

  _handleTask: (obj, cb)=>

  _addTask: (data, cb)=>


module.exports = TaskHandler
