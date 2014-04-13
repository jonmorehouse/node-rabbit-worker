stream = require 'stream'
path = require 'path'
fs = require 'fs'
touch = require 'touch'
watch = require 'watch'
async = require 'async'

class FileSubscriberStream extends stream.Readable


  constructor: (@filenames, @dir)->

    if not @dir?
      @dir = path.dirname require.main.filename
    super

  _read: (size)->

    @pathSetUp (err) =>
      return @push null if err? 
      # initialize a handler for each of the files needed
      @handler (err, filename)->

  pathSetUp: (cb)->

    paths = (path.join @dir, filename for filename in @filenames)
    # make sure all the files are created
    async.each paths, touch, (err)->
      return cb? err if err?
      cb?()

  handler: (cb)->
    # create a monitor for the files
    watch.createMonitor @dir, (monitor)->
      monitor.on "changed", (filename, curr, prev)->
        cb null, filename

class FileSubscriber extends stream.PassThrough

  @dir = path.dirname require.main.filename
  @filenames = [".graceful", ".restart", ".kill"]

  constructor: ->

    super
    if not FileSubscriber.subscriber?
      FileSubscriber.subscriber = new FileSubscriberStream FileSubscriber.filenames, FileSubscriber.dir
  
    # link up the subscriber to this as needed
    FileSubscriber.subscriber.pipe @

module.exports = FileSubscriber

