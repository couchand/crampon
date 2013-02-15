# metadata inference

mmd = require './mmd.coffee'

class Inferrer
  constructor: ->
    @object_types = {}

  analyze: (xml) ->
    d = mmd xml
    @object_types = d
    d

module.exports =
  Inferrer: Inferrer
