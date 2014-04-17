Node Rabbit Worker
==================

A queue worker for handling tasks with RabbitMQ

Usage
-----

```
RabbitWorker = require 'rabbit-worker'

opts = 
  workers: 2 # number of simultaneous tasks
  queue: # a queue object

  # optional if you don't include a queue object
  queueName:
  queueOptions

worker = new RabbitWorker opts

worker.on "data", (task)->
  
  # handle task here
  worker.write task

worker.on "end", ->

worker.on "error", -> 

worker.close (err)->

```

Contributing
------------

* make sure to have RabbitMQ up and running on machine `brew install rabbitmq`
* run all tests `cake test`
* note - sometimes when running tests if things broken, you may need to flush your local rabbitmq queues for any hanging processes / queues





