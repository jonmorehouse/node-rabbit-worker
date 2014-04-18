stream = require 'stream'
require "../bootstrap"
TaskHandler = libRequire 'task_handler'
uuid = require 'uuid'

module.exports = 

  setUp: (cb)->

    @handler = new TaskHandler() 
    @id = uuid.v1()
    @fixture = 

      retryCalled: 0
      retry: ->
        @retryCalled += 1

      acknowledgeCalled: 0
      acknowledge: ->
        @acknowledgeCalled += 1

    cb?()

  tearDown: (cb)->

    cb?()

  testInvalidId: (_test)->

    @handler.on "error", (err)->
      do _test.done

    @handler.write 5

  testSuccess: (test)->

    do test.done

  testError: (test)->

    do test.done


