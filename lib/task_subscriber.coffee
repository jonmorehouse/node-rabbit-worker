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
    cb?()


  _write: (chk, size, enc)->

    @_handleTask chk

  _read: (size)->

    # emit a new task when we are ready
    @queue.subscribe {ack: true}, (message, headers, deliveryInfo, messageObject)=>

      id = uuid.v4()
      obj = 
        id: id
        msg: message

      @tasks[id] = true
      @push obj

  _handleTask: (id)->

    if @tasks[id]?
      delete @tasks[id]
    else
      @error.write new Error "Invalid task handled #{id}"

    @queue.shift()

module.exports = TaskSubscriber

