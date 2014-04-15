bootstrap = require "../bootstrap"
Manager = libRequire "manager"

module.exports = 

  setUp: (cb)->

    @manager = new 
    bootstrap.setUp ->
      cb?()

  tearDown: (cb)->
    bootstrap.tearDown ->
      cb?()

  test: (test)->

    test.done()

