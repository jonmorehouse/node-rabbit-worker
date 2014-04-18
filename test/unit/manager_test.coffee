bootstrap = require "../bootstrap"
{utilities} = require "../bootstrap"
Manager = libRequire "manager"


module.exports = 

  setUp: (cb)->

    bootstrap.setUp =>
      new Manager {queue: queue}, (err, manager)=>
        @manager = manager
        cb?()

  tearDown: (cb)->
    @manager.close ->
      bootstrap.tearDown ->
        cb?()

  managerAttributes: (test)->

    @manager.on "data", (task)=>
    @manager.subscriber.on "ready", =>

      test.equals @manager.error?, true
      test.equals @manager.logger?, true

      # come back to this
      test.equals @manager.subscriber?, true
      test.equals @manager.handler?, true

      # close subscriber
      test.equals @manager.close?, true
      test.done()

  managerSubscribe: (test)->

    @manager.on "data", (task)=>
      @manager.write {id: task.id}
      do test.done

    @manager.subscriber.on "ready", =>
      utilities.publish (err)->

