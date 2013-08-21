# Coffeescript

###
#   Module dependencies.
###

program = require "commander"
_       = require 'underscore'
async   = require 'async'
moment  = require 'moment'

# Define Option
program.version("0.0.1")
.option("-s, --stream [value]", "select Streamname(e.g.'nikezono')")
.parse process.argv

# Instance Variables
updated = 0
stream  = program.stream

# Color Schema
red = "\u001b[31m"
blue = "\u001b[34m"
reset = "\u001b[0m"

# Start Processing
process.nextTick ->

  ### socket.io Configration ###
  client = require 'socket.io-client'
  socket = client.connect "http://unific.net"
  socket.on 'connect', ->

    console.info "Add Stream '#{stream}'. Please Wait for Sync"

    # on first sync
    socket.emit 'sync stream',
      stream:stream
      latest:(new Date()).getTime() - 1000*60*60 # 一時間

    socket.on 'sync completed', (pages)->
      sorted = _.sortBy pages, (obj)->
        return Date.parse obj.page.pubDate
      updated = sorted[0].page.pubDate
      
      sync sorted

    setInterval ->
      socket.emit 'sync stream',
        stream:stream
        latest:updated
    ,1000*60

sync = (sorted)->
  async.eachSeries sorted, (article,cb)->
    date = moment(article.page.pubDate).format("hh:mm");
    title = article.page.title
    site  = article.feed.site

    # ゆっくり見せる
    setTimeout ->
      console.log "[#{date}] #{blue}#{title}#{reset} - #{site}"
      cb()
    ,100
  
  ,->

