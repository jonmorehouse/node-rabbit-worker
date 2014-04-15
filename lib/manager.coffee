stream = require 'stream'

class Manager extends stream.Readable

  ###
    @opts = 
      queue: required - queue to subscribe to (required)
      error: a writable stream that can be written to  (optional)
      logger: a logging writable stream  (optional)
      simultaneous: number of simultaneous workers that we can have
  ###
  constructor: (@opts)->
  
    if not @opts? or not @opts.queue?
      throw new Error "Missing required parameters"
    
    [@_createErrorStream, @_createLogStream, @_createTaskHandler, @_createTaskSubscriber]

    super

  close: ()->

  # private stream methods
  _read: (size)->

    # emit a new task

  _write: ()->
  
  # initialization of various internal streams as needed
  _createErrorStream: (cb)->

  _createLogStream: (cb)->
  
  _createTaskHandler: (cb)->

  _createTaskSubscriber: (cb)->




module.exports = Manager
