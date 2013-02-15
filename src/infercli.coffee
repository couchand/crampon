# metadata inference

l = require './loader.coffee'
mmd = require './mmd.coffee'

main = (argv) ->
  if !argv[1]?
    console.log "Usage: coffee infer.coffee FILE [ FILE ... ]"
    return

  object_types = {}

  for file in argv.slice 1
    object_types = mmd l(file), object_types

  console.log JSON.stringify object_types

main process.argv.slice 1
