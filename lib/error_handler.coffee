stream = require 'stream'

class ErrorHandler extends stream.Transform

  constructor: ->
    super
      objectMode: true

  _write: (chk, size, enc)->
    @push chk

module.exports = ErrorHandler
