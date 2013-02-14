# test parsing xml

fs = require 'fs'
difflet = require 'difflet'

load = require '../../src/loader.coffee'
node = require '../../src/nodes.coffee'

data = load 'test/fixture/SObjectType__c.object'
expected = JSON.parse fs.readFileSync('test/expect/SObjectType__c.json').toString()

actual = node.build data

console.log difflet({ indent: 2, comment: true}).compare expected, actual
