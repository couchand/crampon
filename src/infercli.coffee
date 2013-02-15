#!/usr/local/bin/coffee
# inference command line interface

l = require './loader.coffee'
i = require './infer.coffee'

main = (argv) ->
  if !argv[1]?
    console.log "Usage: coffee infer.coffee FILE [ FILE ... ]"
    return

  sherlock = new i.Inferrer()

  for file in argv.slice 1
    sherlock.analyze l file

  console.log JSON.stringify sherlock.object_types

main process.argv.slice 1
