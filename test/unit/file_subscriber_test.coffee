bootstrap = require "../bootstrap"
FileSubscriber = libRequire "file_subscriber"

subscriber = null


module.exports = 

  setUp: (cb)->

    subscriber = new FileSubscriber()
    subscriber.setEncoding "utf-8"
    cb?()
  
  test: (test)->

    subscriber.on "data", (data)->

      p data
      do test.done
