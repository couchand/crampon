'use strict'

class Factory
  build: (tag) ->
    switch tag.tag
      when 'fields'
        Builder = Field
      when 'foobar'
        Builder = Field
      else throw 'unknown tag type'
    thing = new Builder()
    tag.getchildren().forEach (child) ->
      thing.set child.tag, child.text
    thing

class Field
  constructor: ->
  set: (field, value) ->
    switch field
    # required
      when 'fullName'
        @fullName = value
      when 'label'
        @label = value
      when 'type'
        @type = new Type value
      when 'length'
        @length = parseInt value, 10
      when 'trackHistory'
        @trackHistory = value is 'true'

    # common
      when 'externalId'
        @externalId = value is 'true'
      when 'required'
        @required = value is 'true'
      when 'unique'
        @unique = value is 'true'

    # others
      when 'caseSensitive'
        @caseSensitive = value is 'true'
      when 'defaultValue'
        @defaultValue = value
      when 'picklist'
        @picklist = new Picklist value
      when 'visibleLines'
        @visibleLines = parseInt value, 10
      else throw 'unknown field on field object'

class Type
  constructor: (@value) ->

class Picklist
  constructor: (@value) ->

module.exports =
  Field: Field
  factory: new Factory()
