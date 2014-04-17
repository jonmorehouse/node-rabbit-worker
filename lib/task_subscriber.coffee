stream = require 'stream'
async = require 'async'

class TaskSubscriber extends stream.Duplex

  constructor: (@queue, @max, @logger, @error, cb)->

    super {objectMode: true}
    for attr in [@queue, @max, @logger, @error]
      if not attr?
        err = new Error "Missing parameter"
        return cb? err 
        throw err
    @tasks = {}
    @_bootstrap =>
      cb? null, @

  _bootstrap: (cb)=>
    
    # make sure we are subscribed to the queue
    cb?()

  _write: (chk, size, enc)->

    # a task was handled
    # remove the id from the hash
    # now q.shift() # this will allow a new 

  _read: (size)->

    @push "HERE"
    # emit a new task when we are ready
    @queue.subscribeRaw (msg)=>

      p "MSG RECIEVED"
      

module.exports = TaskSubscriber
