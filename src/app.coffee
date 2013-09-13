# Coffeescript

###
#   Module dependencies.
###

program = require "commander"
_       = require 'underscore'
async   = require 'async'
moment  = require 'moment'
colors  = require 'colors'

###
#  Module Configration
###

# Color Schema
colors.setTheme
  time: 'grey'
  verbose: 'cyan'
  prompt: 'grey'
  info: 'blue'

# Random Colors
color = ["white",'yellow', 'cyan', 'magenta', 'red', 'green', 'blue' ]
cnumber = 0


###
# Main Script
###

# Define Option
program.version("0.2.0")
.option("-s, --stream [value]", "select Streamname(e.g.'nikezono')")
.parse process.argv

# Instance Variables
updated  = (new Date()).getTime() - 1000*60*60 # デフォルト:一時間前
stream   = program.stream
titles   = []

# Start Processing
process.nextTick ->

  return console.log "Please input stream name.exit..." unless stream

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
        uniqued = _.filter pages,(article)->
          return if article.page.title in titles then false else true

        return if _.isEmpty uniqued
        sorted = _.sortBy uniqued, (article)->
          return Date.parse article.page.pubDate

        updated = Date.parse(_.last(sorted).page.pubDate)
        _.map sorted,(article)->
          titles.push article.page.title

        return render sorted

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

    date  = "[#{moment(article.page.pubDate).format("(ddd) HH:mm")}]".time
    title = article.page.title[color[cnumber]]
    site  = article.feed.title
    url   = article.page.url.underline

    # ゆっくり見せる
    setTimeout ->
      console.log "#{date} #{title} - #{site}:#{url}"
      cb()
    ,100

  ,->

