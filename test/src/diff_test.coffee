# test parsing xml

fs = require 'fs'
difflet = require 'difflet'

load = require '../../src/loader.coffee'
node = require '../../src/nodes.coffee'

v1 = load 'test/fixture/v1/SObjectType__c.object'
v2 = load 'test/fixture/v2/SObjectType__c.object'
#expected = JSON.parse fs.readFileSync('test/expect/v1/SObjectType__c.json').toString()

actual1 = node.build v1
actual2 = node.build v2

console.log difflet({ indent: 2, comment: true}).compare actual1, actual2
