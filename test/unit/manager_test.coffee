#bootstrap = require "../bootstrap"
#Manager = libRequire "manager"


#module.exports = 

  #setUp: (cb)->

    #bootstrap.setUp =>
      #@manager = new Manager {queue: queue}, (err)->

        #cb?()

  #tearDown: (cb)->
    #bootstrap.tearDown ->
      #cb?()

  #managerAttributes: (test)->

    #test.equals @manager.error?, true
    #test.equals @manager.logger?, true

    ## come back to this
    ##test.equals @manager.subscriber?, true
    #test.done()




