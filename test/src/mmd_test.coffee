# test for meta-metadata

load = require '../../src/loader.coffee'
mmd = require '../../src/mmd.coffee'

data = load 'test/fixture/v1/SObjectType__c.object'

console.log mmd data
