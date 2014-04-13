stream = require 'stream'
path = require 'path'
fs = require 'fs'
touch = require 'touch'
watchr = require 'watchr'
async = require 'async'

class FileSubscriberStream extends stream.Readable

  constructor: (@filenames, @dir)->

    if not @dir?
      @dir = path.dirname require.main.filename
    @paths = (path.join @dir, filename for filename in @filenames)
    super

  _read: (size)->

    @pathSetUp (err) =>
      return @push null if err? 
      # initialize a handler for each of the files needed
      @handler (err)=>

        
  pathSetUp: (cb)->

    # make sure all the files are created
    async.each @paths, touch, (err)->
      return cb? err if err?
      cb?()

  handler: (cb)->
    watchr.watch 
      path: @paths[0],
      listeners:
        #log: null
        #error: null
        watching: (err, watcherInstance, isWatching)=>
          p "HERE"

        change: (changeType, filePath, stat, prevStat)=>
          p "TEST"
          @push filePath
      next: (err, watchers)=>
        p "READY"
        return cb? err if err
        @watchers = watchers
        cb?()

  close: (cb)->
    watcher.close() for watcher in @watchers
    for watcher in @watchers
      p "HERE"

class FileSubscriber extends stream.PassThrough

  @dir = path.dirname require.main.filename
  @filenames = [".graceful", ".restart", ".kill"]

  constructor: ->

    super
    if not FileSubscriber.subscriber?
      FileSubscriber.subscriber = new FileSubscriberStream FileSubscriber.filenames, FileSubscriber.dir
  
    # link up the subscriber to this as needed
    FileSubscriber.subscriber.pipe @

  close: ->

    subscriber = FileSubscriber.subscriber
    if subscriber?
      subscriber.close()

module.exports = FileSubscriber
