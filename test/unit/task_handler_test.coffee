require "../bootstrap"
TaskHandler = libRequire 'task_handler'
uuid = require 'uuid'

module.exports = 

  setUp: (cb)->

    @handler = new TaskHandler testStream, testStream
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

  testInvalidId: (test)->

    #@handler.write {}
    #@handler.write @id
    @handler.write 4
    @handler.on "error", (err)->

      p "HEADASDF"
      p err

      do test.done

  testSuccess: (test)->

    do test.done

  testError: (test)->

    do test.done


