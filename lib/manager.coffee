stream = require 'stream'
async = require 'async'
ErrorHandler = require './error_handler'
LogHandler = require './log_handler'

class Manager extends stream.Readable

  ###
    @opts = 
      queue: required - queue to subscribe to (required)
      error: a writable stream that can be written to  (optional)
      logger: a logging writable stream  (optional)
      simultaneous: number of simultaneous workers that we can have
  ###
  constructor: (@opts, cb)->

    super
    if not @opts? or not @opts.queue?
      err = new  Error "Missing required parameters"
      return cb err if cb? 
      throw err
      
    methods = [
      @_createErrorStream, 
      @_createLogStream, 
      @_createTaskHandler, 
      @_createTaskSubscriber
    ]

    # call each method before our final callback
    async.waterfall methods, (err)=>
      return cb? err if err
      cb? null, @

  close: ()->

  # private stream methods
  _read: (size)->

    # emit a new task

  _write: ()->
  
  # initialization of various internal streams as needed
  _createErrorStream: (cb)=>

    # case where we have passed in an error stream
    if @opts.errors?
      @error = @opts.error
      return cb?()
    
    # no error handler passed in
    @error = new ErrorHandler()
    cb?()

  _createLogStream: (cb)=>

    if @opts.logger?
      @logger = @opts.logger
      return cb?()

    # no logger passed in
    @logger = new LogHandler()
    cb?()

  _createTaskHandler: (cb)->

    cb?()

  _createTaskSubscriber: (cb)->

    cb?()


module.exports = Manager
