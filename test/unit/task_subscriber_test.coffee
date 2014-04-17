stream = require 'stream'
bootstrap = require "../bootstrap"
async = require 'async'
{utilities} = require "../bootstrap"
TaskSubscriber = libRequire "task_subscriber"

module.exports = 

  setUp: (cb)->
    @messages = (utilities.publish for i in [1..10])
    bootstrap.setUp =>
      new TaskSubscriber queue, 2, testStream, testStream, (err, manager)=>
        @manager = manager
        cb?()

  tearDown: (cb)->
    @manager.close()
    bootstrap.tearDown =>
      cb?()

  testRun: (test)->

    called = 0
    @manager.on "data", (data)=>
      test.equal true, data?
      test.equal true, data.id?
      test.equal true, data.msg?
      called += 1

      if called < @messages.length
        @manager.write data.id
      else
        do test.done

    async.waterfall @messages, (err)->

  test: (test)->

    do test.done



    o
