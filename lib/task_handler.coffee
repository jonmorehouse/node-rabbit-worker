stream = require 'stream'

class TaskHandler extends stream.Writable

  constructor: (@error, @logger) ->

    super 
      objectMode: true
    @_tasks = {}

  _write: (obj, enc, cb)->
    
    if not typeof obj == "object" or not obj.id?
      return cb new Error "Invalid parameter"

    if @_tasks[obj.id]?
      @_handleTask obj, cb
    else
      @_addTask obj, cb

  _handleTask: (obj, cb)=>

    task = @_tasks[obj.id]
    if not task?
      return cb new Error "Race condition. Task already deleted"
    delete @_tasks[obj.id]
    if obj.error? or obj.err?
      task.retry()
    else
      task.acknowledge()
    cb?()

  _addTask: (obj, cb)=>

    @_tasks[obj.id] = obj
    cb?()

module.exports = TaskHandler
