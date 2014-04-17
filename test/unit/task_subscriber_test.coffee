stream = require 'stream'
bootstrap = require "../bootstrap"
TaskSubscriber = libRequire "task_subscriber"

module.exports = 

  setUp: (cb)->
    bootstrap.setUp =>
      cb?()

  tearDown: (cb)->

    bootstrap.tearDown =>
      cb?()

  test: (test)->


    do test.done



