stream = require 'stream'
bootstrap = require "../bootstrap"
{utilities} = require "../bootstrap"
TaskSubscriber = libRequire "task_subscriber"

module.exports = 

  setUp: (cb)->
    bootstrap.setUp =>
      cb?()

  tearDown: (cb)->

    bootstrap.tearDown =>
      cb?()

  test: (test)->

    utilities.publish {test: "TEST"}, (err)->

      queue.subscribeRaw (msg)->

        do test.done



