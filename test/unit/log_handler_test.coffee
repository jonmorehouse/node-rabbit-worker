bootstrap = require "../bootstrap"
#{Worker} = libRequire "index"

module.exports = 

  setUp: (cb)->

    bootstrap.setUp ->
      cb?()

  tearDown: (cb)->

    bootstrap.tearDown ->
      cb?()

  #test: (test)->

    #test.done()

