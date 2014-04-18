stream = require 'stream'
require "../bootstrap"
TaskHandler = libRequire 'task_handler'
uuid = require 'uuid'

module.exports = 

  setUp: (cb)->

    @fixture = 
      id:  uuid.v1()
      retryCalled: 0
      retry: ->
        @retryCalled += 1
      acknowledgeCalled: 0
      acknowledge: ->
        @acknowledgeCalled += 1

    @handler = new TaskHandler() 
    @handler.write @fixture
    @handler.on "error", (err)=>
      @error = err

    cb?()

  tearDown: (cb)->

    cb?()

  testInvalidId: (test)->

    @handler.write {noId: "noid"}
    test.equals true, @error?
    do test.done

  testError: (test)->

    @handler.write "random string"
    test.equals true, @error?
    @error = null
    @handler.write 1
    test.equals true, @error?
    do test.done

  testRetryHandler: (test)->

    @handler.write {id: @fixture.id, err: true}
    test.equals @fixture.retryCalled, 1
    test.equals @fixture.acknowledgeCalled, 0
    do test.done

  testSuccessHandler: (test)->

    @handler.write {id: @fixture.id}
    test.equals @fixture.retryCalled, 0
    test.equals @fixture.acknowledgeCalled, 1
    test.equals @handler._tasks[@fixture.id]?, false
    do test.done

