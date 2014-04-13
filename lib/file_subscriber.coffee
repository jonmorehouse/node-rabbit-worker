stream = require 'stream'
path = require 'path'
fs = require 'fs'
touch = require 'touch'
watch = require 'watch'

class FileSubscriberStream extends stream.Readable

  @handles:
    graceful: 
      filename: ".graceful"
      name: "Graceful"
    restart:
      filename: ".restart"
      name: "Restart"
    kill:
      filename: ".kill"
      name: "Kill"

  constructor: (@fileDir)->

    super
    if not @fileDir?
      @fileDir = path.dirname require.main.filename

  _read: (size)->

    handleCb = ->
      @push null
    
    # initialize a handler for each of the files needed
    handles = FileSubscriberStream.handles
    @handler handles[key], handleCb for key of handles
    @push "data"
    @push null

  handler: (obj, cb)->

    # first make sure file exists / otherwise create it
    _path = path.join @fileDir, obj.filename
    
    # make sure file exists ...
    fs.exists _path, (exists)->
      # create it if necessary
      touch _path, (err, st)->
        p err
        p st

class FileSubscriber extends stream.PassThrough

  constructor: ->

    super
    if not FileSubscriber.subscriber?
      FileSubscriber.subscriber = new FileSubscriberStream()
  
    # link up the subscriber to this as needed
    FileSubscriber.subscriber.pipe @

module.exports = FileSubscriber

