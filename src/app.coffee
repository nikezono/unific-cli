# Coffeescript

###
#   Module dependencies.
###

program = require "commander"

# Define Option
program.version("0.0.1")
.option("-s, --stream [value]", "select Streamname(e.g.'nikezono')")
.parse process.argv

# Instance Variables
updated = 0
stream  = program.stream

console.info "Add Stream '#{stream}'. Please Wait for Sync"

process.nextTick ->
  sync stream,updated
  setInterval ->
    sync stream,updated
  ,1000*60

sync = (stream,updated)->
  console.log stream
  console.log updated
