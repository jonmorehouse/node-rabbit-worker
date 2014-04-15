bootstrap = require "../bootstrap"
ErrorHandler = libRequire "error_handler"

module.exports = 

  setUp: (cb)->

    @handler = new ErrorHandler()
    bootstrap.setUp ->
      cb?()

  tearDown: (cb)->

    @handler.end()
    bootstrap.tearDown ->
      cb?()

  testErrorHandler: (test)->

    data = {key: "value"}
    @handler.write data
    @handler.on "data", (_data)->
      test.equals data, _data
      do test.done


