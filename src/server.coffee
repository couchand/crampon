# diff server

http = require 'http'

diff = require './diff.coffee'

main = (argv) ->
  if !argv[1]? or !argv[2]?
    console.log "Usage: coffee server.coffee OLD_FILE NEW_FILE"
    return

  server = http.createServer (req, res) ->
    console.log 'ping'

    page = diff argv[1], argv[2]

    res.writeHeader 200,
      "Content-type": "text/html"
    res.write page
    res.end()

  server.listen 8080

  console.log 'server listening on https://localhost:8080'

main process.argv.slice 1
