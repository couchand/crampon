# meta-metadata

class NodeType
  constructor: (name) ->
    @name = name
    @isPlural = no
    @values = []
    @children = {}

  plural: ->
    @isPlural = yes

  addValue: (val) ->
    @values.push val

  addChild: (name) ->
    @children[name] = new NodeType name

analyze = (et, continuing) ->
  root = new NodeType 'root'
  root.children = continuing if continuing?
  analyzeNode root, et
  root.children

analyzeNode = (parent_type, node) ->
  children = node.getchildren()
  this_type = parent_type.children[node.tag]

  if this_type?
    this_type.plural on
  else
    this_type = parent_type.addChild node.tag

  if children.length is 0
    this_type.addValue node.text
  else
    for child in children
      analyzeNode this_type, child

module.exports = analyze
