'use strict'

class Factory
  build: (tag) ->
    switch tag.tag
      when 'CustomObject'
        Builder = SObject
      when 'fields'
        Builder = Field
      when 'picklistValues'
        Builder = PicklistValue
      when 'actionOverrides'
        Builder = ActionOverride
      else throw new Error "unknown tag type #{tag.tag}"
    thing = new Builder()
    tag.getchildren().forEach (child) ->
      thing.set child.tag, child.text, child
    thing.finishBuild() if thing.finishBuild
    thing

factory = new Factory()

class SObject
  constructor: ->
    @fields = {}
    @actionOverrides = {}
  set: (field, value, tag) ->
    switch field
    # named children
      when 'fields'
        field = factory.build tag
        @fields[field.fullName] = field
      when 'actionOverrides'
        action = factory.build tag
        @actionOverrides[action.actionName] = action

    # smart members
      when 'sharingModel'
        @sharingModel = new SharingModel value
      when 'deploymentStatus'
        @deploymentStatus = new DeploymentStatus value
      when 'listViews', 'nameField', 'searchLayouts'
        # TODO: something
        ''

    # regular members
      when 'label'
        @label = value
      when 'pluralLabel'
        @pluralLabel = value
      when 'enableActivities'
        @enableActivities = value is 'true'
      when 'enableFeeds'
        @enableFeeds = value is 'true'
      when 'enableHistory'
        @enableHistory = value is 'true'
      when 'enableReports'
        @enableReports = value is 'true'
      else throw new Error "unknown field #{field} on custom object object"

class Field
  finishBuild: ->
    @defaultValue = @type.cast @defaultValue if @defaultValue
  set: (field, value, tag) ->
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
        @picklist = new Picklist tag
      when 'visibleLines'
        @visibleLines = parseInt value, 10
      else throw new Error "unknown field #{field} on field object"

class DeploymentStatus
  constructor: (@status) ->

class SharingModel
  constructor: (@model) ->

class Type
  constructor: (@value) ->
  cast: (obj) ->
    if @value is 'Checkbox'
      return obj is 'true'
    obj

class Picklist
  constructor: (tag) ->
    @sorted = tag.find('./sorted').text is 'true'
    plvs = @picklistValues = []
    tag.findall('./picklistValues').forEach (plv) ->
      plvs.push factory.build plv

class PicklistValue
  set: (field, value, tag) ->
    switch field
      when 'fullName'
        @fullName = value
      when 'default'
        @default = value is 'true'
      else throw new Error "unknown field #{field} on picklist value object"

class ActionOverride
  set: (field, value, tag) ->
    switch field
      when 'actionName'
        @actionName = value
      when 'type'
        @type = value
      else throw new Error "unknown field #{field} on picklist value object"

module.exports = factory
