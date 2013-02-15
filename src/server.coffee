# diff server

http = require 'http'
fs = require 'fs'
url = require 'url'

load = require './loader.coffee'
node = require './nodes.coffee'
diff = require './diff.coffee'

normalizeArgs = (arg) ->
  left = arg[1]
  right = arg[2]
  ls = fs.statSync left
  rs = fs.statSync right
  if ls.isFile() and rs.isFile()
    return [[left], [right]]
  if ls.isFile() and rs.isDirectory() or ls.isDirectory() and rs.isFile()
    throw new Error 'arguments must be of the same type'
  lfs = fs.readdirSync left
  rfs = fs.readdirSync right
  los = (left + '/' + file for file in lfs when file and file.match(/\.object$/))
  ros = (right + '/' + file for file in rfs when file and file.match(/\.object$/))
  return [los, ros]

objectName = (filepath) ->
  return filepath.replace /^.*\/([^\/]*)\.object/, '$1'

listObjects = (lists) ->
  page = """
         <html>
           <body>
             <h1>Diffing</h1>
         """

  only_in_left = {}
  show_left = false
  only_in_right = {}
  show_right = false
  in_both = {}
  show_both = false

  for file in lists[0]
    objName = objectName file
    if lists[1].indexOf file
      show_both = true
      in_both[objName] = file
    else
      show_left = true
      only_in_left[objName] = file
  for file in lists[1]
    objName = objectName file
    if lists[0].indexOf file
      show_both = true
      in_both[objName] = file
    else
      show_right = true
      only_in_right[objName] = file

  if show_left
    page += """
            <h3>Only in left</h3>
            <ul>
            """
    for obj, file of only_in_left
      page += "<li><a href='?f=#{obj}'>#{obj}</a></li>"
    page += '</ul>'
  if show_right
    page += """
            <h3>Only in right</h3>
            <ul>
            """
    for obj, file of only_in_right
      page += "<li><a href='?f=#{obj}'>#{obj}</a></li>"
    page += '</ul>'
  if show_both
    page += """
            <h3>In both</h3>
            <ul>
            """
    for obj, file of in_both
      page += "<li><a href='?f=#{obj}'>#{obj}</a></li>"
    page += '</ul>'
  page += """
            </body>
          </html>
          """

diffObjects = (f1, f2) ->
  prev = node.build load f1
  next = node.build load f2
  diff prev, next

findFile = (name, dirs) ->
  l = r = false
  re = new RegExp name
  for dir in dirs[0]
    l = dir if dir.match re
  for dir in dirs[1]
    r = dir if dir.match re
  [l, r]

main = (argv) ->
  if !argv[1]? or !argv[2]?
    console.log "Usage: coffee server.coffee OLD_DIR NEW_DIR"
    return

  dirs = normalizeArgs argv

  server = http.createServer (req, res) ->
    console.log 'ping'

    { query: params } = url.parse req.url, true
    console.log params

    if params and params.f
      [l,r] = findFile params.f, dirs
      page = diffObjects l, r
    else
      page = listObjects dirs

    res.writeHeader 200,
      "Content-type": "text/html"
    res.write page
    res.end()

  server.listen 8080

  console.log 'server listening on https://localhost:8080'

main process.argv.slice 1
