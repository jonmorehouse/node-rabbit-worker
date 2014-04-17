nodeunit = require 'nodeunit'
{spawn} = require 'child_process'
{print} = require 'sys'
bootstrap = require './test/bootstrap'

task "test", "Run all tests", ->

  reporter = nodeunit.reporters.verbose
  reporter.run ["test/unit"]

task "build", "Build jslib", ->

  coffee = spawn 'coffee', ['-c', '-o', 'jslib', 'lib']
  coffee.stderr.on 'data', (data)->
    print data.toString()

  coffee.stdout.on 'data', (data)->
    print data.toString()

