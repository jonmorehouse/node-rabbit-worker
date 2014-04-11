class Worker

  ###
  opts:
    queue: queue - in case of anything weird
    conn: queueName
    queueName: string name of queue to attach to
    parallel: quantity of simultaneous elements

  events:
    data: {taskID: task}
    exit: all tasks are completed
      
  methods:
    complete: job completed by worker
    error: job failed 
    exit: exit entire worker
  ###
  @construct: (opts)->



module.exports = 
  worker: Worker
