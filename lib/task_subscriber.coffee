stream = require 'stream'
async = require 'async'
uuid = require 'uuid'

class TaskSubscriber extends stream.Duplex

  constructor: (@queue, @max, @logger, @error, cb)->

    super {objectMode: true}
    for attr in [@queue, @max, @logger, @error]
      if not attr?
        err = new Error "Missing parameter"
        return cb? err 
        throw err
    @tasks = {}
    cb null, @


  close: ->
    @stopped = true
    @push null
    @queue.unsubscribe 

  _write: (chk, size, enc)->

    @_handleTask chk
    @_shifter

  _read: (size)->

    if not @subscribed and not @stopped
      @subscribed = true
      # emit a new task when we are ready
      @queue.subscribe {ack: true}, (message, headers, deliveryInfo, messageObject)=>
          @_newTask message

  _newTask: (msg)->

      id = uuid.v4()
      obj = 
        id: id
        msg: msg

      @tasks[id] = true
      @push obj
      @queue.shift()

  _shifter: ->
      length = (key for key of @tasks).length
      if length > 0 and length <= @max
        @queue.shift()

  _handleTask: (id)->

    if @tasks[id]?
      delete @tasks[id]
    else
      @error.write new Error "Invalid task handled #{id}"

module.exports = TaskSubscriber

