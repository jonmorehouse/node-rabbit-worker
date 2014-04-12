Node Rabbit Worker
==================

A queue worker for handling command

Features
--------

* smart stop/start for handling / abstracting rabbit
  * watch file for change (touch event)
* pass in queueName / connection
* emits tasks

Contributing
------------

* make sure to have RabbitMQ up and running on machine `brew install rabbitmq`
* run all tests `cake test`



