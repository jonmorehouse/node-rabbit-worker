path = require "path"

baseDirectory = path.resolve path.join __dirname, ".."

# modify global namespace
global.p = console.log
global.libRequire = (_path)->
  return require path.join baseDirectory, "lib", _path

