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
colors.setTheme
  time: 'grey'
  verbose: 'cyan'
  prompt: 'grey'
  info: 'blue'

color = ["white",'yellow', 'cyan', 'magenta', 'red', 'green', 'blue' ]
cnumber = 0

# Define Option
program.version("0.0.1")
.option("-s, --stream [value]", "select Streamname(e.g.'nikezono')")
.parse process.argv

# Instance Variables
updated = (new Date()).getTime() - 1000*60*60 # デフォルト:一時間前
stream  = program.stream

# Start Processing
process.nextTick ->

  ### socket.io Configration ###
  client = require 'socket.io-client'
  socket = client.connect "http://unific.net"
  socket.on 'connect', ->

    console.log "Add Stream '#{stream.blue}'. Please Wait for Sync"

    # on first sync
    socket.emit 'sync stream',
      stream:stream
      latest:updated

    socket.on 'sync completed', (pages)->
      if pages.length > 0
        sorted = _.sortBy pages, (obj)->
          return Date.parse obj.page.pubDate
        updated = Date.parse(_.last(sorted).page.pubDate)

        render sorted

    setInterval ->
      socket.emit 'sync stream',
        stream:stream
        latest:updated
    ,1000*60

render = (sorted)->
  async.eachSeries sorted, (article,cb)->

    # フィード名から色を算出
    # とりあえず文字数/カラー数のあまり
    # 偏差が出るので
    seed = parseInt(article.feed._id)+article.feed.title.length
    cnumber = seed%color.length

    date = "[#{moment(article.page.pubDate).format("hh:mm")}]".time
    title = article.page.title[color[cnumber]]
    site  = article.feed.site.underline

    # ゆっくり見せる
    setTimeout ->
      console.log "#{date} #{title} - #{site}"
      cb()
    ,100
  
  ,->

