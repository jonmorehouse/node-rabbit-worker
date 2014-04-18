stream = require 'stream'
async = require 'async'
uuid = require 'uuid'

class TaskSubscriber extends stream.Readable

  constructor: (@queue, @maxTasks, @handler, @logger, @error, cb)->

    super {objectMode: true}
    for attr in [@queue, @maxTasks, @logger, @error, @handler]
      if not attr?
        err = new Error "Missing parameter"
        return cb? err 
        throw err
    cb null, @

  close: (cb)=>
    @stopped = true
    us = @queue.unsubscribe @consumerTag
    us.addCallback =>
      @push null
      cb?()

  _read: (size)->

    if not @subscribed and not @stopped
      @subscribed = true

      # emit a new task when we are ready
      subscription = @queue.subscribe {ack: true, prefetchCount: @maxTasks}, @_msgReciever

      # grab / store consumer tag
      subscription.addCallback (ok)=>
        @consumerTag = ok.consumerTag
        @queue.on "basicQosOk", (data)=>
        emit = @emit "ready"

  _msgReciever: (message, headers, deliveryInfo, messageObject)=>

    id = uuid.v1()
    messageObject.id = id
    @handler.write messageObject
    @push 
      id: id
      headers: headers
      msg: message

module.exports = TaskSubscriber
