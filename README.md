Node Rabbit Worker
==================

A queue worker for handling tasks with RabbitMQ

Usage
-----

```
RabbitWorker = require 'rabbit-worker'

opts = 
  max: 2 # number of simultaneous tasks
  queue: # a queue object
  error: # a writable stream for error handling
  logger: # a writable stream for logging

worker = new RabbitWorker opts

worker.on "data", (task)->
  
  task = 
    id:
    msg:

  # handle task / do work
  # task was successful
  worker.write {id: task.id}
  # task wsa unsuccessful
  worker.write {id: task.id, err: true}

worker.on "ready", ->

  # queue and subscription is now ready

worker.on "error", -> 
  
  # internal worker error

# close out subscription. Handle all remaining tasks
worker.close (err)->
```

Contributing
------------

* make sure to have RabbitMQ up and running on machine `brew install rabbitmq`
* run all tests `cake test`
* note - sometimes when running tests if things broken, you may need to flush your local rabbitmq queues for any hanging processes / queues



