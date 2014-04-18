stream = require 'stream'
async = require 'async'
ErrorHandler = require './error_handler'
LogHandler = require './log_handler'
TaskHandler = require './task_handler'
TaskSubscriber = require './task_subscriber'

class Manager extends stream.Duplex

  ###
    @opts = 
      queue: required - queue to subscribe to (required)
      max: number of simultaneous workers that we can have (default = 2)
      error: a writable stream that can be written to  (optional)
      logger: a logging writable stream  (optional)
  ###
  constructor: (@opts, cb)->

    super {objectMode: true}
    if not @opts? or not @opts.queue?
      err = new  Error "Missing required parameters"
      return cb err if cb? 
      throw err
    
    if not @opts.max? 
      @opts.max = 2

    methods = [
      @_createErrorStream, 
      @_createLogStream, 
      @_createTaskHandler, 
      @_createTaskSubscriber,
      @_pipeErrors,
    ]

    # call each method before our final callback
    async.waterfall methods, (err)=>
      return cb? err if err
      cb? null, @

  close: (cb)->
    @subscriber.on "end", =>
      @handler.close =>
        cb?()

    @subscriber.close()

  # stream api methods
  _read: (size)->

    @subscriber.on "data", (data)=>
      @push data

    @subscriber.on "ready", =>
      @emit "ready"

  _write: (chk, enc, cb)->

    @handler.write chk

  _pipeErrors: (cb)=>

    @subscriber.on "error", (err)=>
      @emit err
    @handler.on "error", (err)=>
      @emit err
    cb?()

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

  _createTaskHandler: (cb)=>

    @handler = new TaskHandler @logger, @error
    cb?()

  _createTaskSubscriber: (cb)=>

    new TaskSubscriber @opts.queue, @opts.max, @handler, @logger, @error, (err, sub)=>

      return cb? err if err
      @subscriber = sub
      cb?()

module.exports = Manager
