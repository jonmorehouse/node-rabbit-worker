stream = require 'stream'

class LogHandler extends stream.Transform

  constructor: ->
    super
      objectMode: true

  _write: (chk, size, enc) ->
    @push chk


module.exports = LogHandler


