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

    bootstrap.tearDown =>
      cb?()

  testThrottling: (test)->

    @manager.on "data", (data)->

    async.waterfall @messages, (err)->

      do test.done






