bootstrap = require "../bootstrap"
LogHandler = libRequire "error_handler"

module.exports = 

  setUp: (cb) ->
    @handler = new LogHandler()
    cb?()

  tearDown: (cb) ->
    @handler.end()
    cb?()

  testLogHandler: (test) ->
    data = {key: "value"}
    @handler.write data
    @handler.on "data", (_data) ->
      test.equals data, _data
      do test.done


