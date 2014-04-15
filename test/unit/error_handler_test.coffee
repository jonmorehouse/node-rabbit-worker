bootstrap = require "../bootstrap"
ErrorHandler = libRequire "error_handler"


module.exports = 

  setUp: (cb)->

    bootstrap.setUp ->
      cb?()

  tearDown: (cb)->

    bootstrap.tearDown ->
      cb?()

  test: (test)->

    test.done()


