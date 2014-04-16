stream = require 'stream'
async = require 'async'

class TaskSubscriber extends stream.Duplex

  constructor: (@queue, @max, @logger, @error, cb)->

    super
    for attr in [@queue, @max, @logger, @error]
      if not attr?
        err = new Error "Missing parameter"
        return cb? err 
        throw err

    methods = [
      @_bootstrap
    ]

    async.waterfall methods, (err)=>

      cb?()

  _bootstrap: (cb)=>

    # make sure we are subscribed to the queue
    cb?()

  _write: (chk, size, enc)->

    # a task was handled

  _read: (size)->

    # emit a new task when we are ready
    #@q.subscribe (message, headers, deliveryInfo, messageObject)->
      #@push messageObject

module.exports = TaskSubscriber
