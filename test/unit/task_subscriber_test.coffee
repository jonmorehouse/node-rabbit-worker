stream = require 'stream'
bootstrap = require "../bootstrap"
async = require 'async'
{utilities} = require "../bootstrap"
TaskSubscriber = libRequire "task_subscriber"

module.exports = 

  setUp: (cb)->
    @messages = (utilities.publish for i in [1..10])
    @handlerStream = new stream.Writable {objectMode: true}
    @handlerStream._write = (msg, enc, cb)=>
      msg.acknowledge()
      cb?()
    bootstrap.setUp =>
      new TaskSubscriber queue, 2, @handlerStream, testStream, testStream, (err, subscriber)=>
        @subscriber = subscriber
        cb?()

  tearDown: (cb)->
    @subscriber.on "end", =>
      bootstrap.tearDown =>
        cb?()
    @subscriber.close()

  testShiftingProperly: (test)->

    called = 0
    @subscriber.on "data", (data)=>
      called += 1
      test.equal true, data?
      test.equal true, data.id?
      test.equal true, data.msg?
      test.equal true, data.headers?

      if called == @messages.length
        do test.done

    @subscriber.on "ready", =>
      # lets you know the queue is ready!
      async.waterfall @messages, (err)->

