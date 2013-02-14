# xml file loader and parser utility for crampon

'use strict'

fs = require 'fs'
et = require 'elementtree'

loadFile = (filepath) ->
  file = fs.readFileSync(filepath).toString()
  et.parse(file).getroot()

module.exports = loadFile
