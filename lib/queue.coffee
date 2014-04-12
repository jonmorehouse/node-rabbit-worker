###
Return a queue object to the caller 

Opts:
  queue: 
  queueName
  conn: 

###
exports.getQueue = (opts, cb)->
  
  returner = (err, value)->

    if err and cb? 
      cb err
    else if err 
      return err
    else if cb? 

  if opts.queue? 
    return returner opts.queue

  if opts.queueName? and opts.conn?
    # generate the queue here
    # block here ...

