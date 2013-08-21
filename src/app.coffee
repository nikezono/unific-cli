# Coffeescript

###
#   Module dependencies.
###

program = require "commander"
_       = require 'underscore'
async   = require 'async'
moment  = require 'moment'
colors  = require 'colors'

# Color Schema
colors.setTheme({
  time: 'grey',
  verbose: 'cyan',
  prompt: 'grey',
  info: 'blue',
});
color = ['yellow', 'cyan', 'magenta', 'red', 'green', 'blue', ]
cnumber = 0

# Define Option
program.version("0.0.1")
.option("-s, --stream [value]", "select Streamname(e.g.'nikezono')")
.parse process.argv

# Instance Variables
updated = 0
stream  = program.stream

# Start Processing
process.nextTick ->

  ### socket.io Configration ###
  client = require 'socket.io-client'
  socket = client.connect "http://unific.net"
  socket.on 'connect', ->

    console.info "Add Stream '#{stream}'. Please Wait for Sync".info

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

    date = "[#{moment(article.page.pubDate).format("hh:mm")}]".time
    title = article.page.title[color[cnumber]]
    site  = article.feed.site.underline

    cnumber = if cnumber is color.length-1 then 0 else cnumber+1

    # ゆっくり見せる
    setTimeout ->
      console.log "#{date} #{title} - #{site}"
      cb()
    ,100
  
  ,->

