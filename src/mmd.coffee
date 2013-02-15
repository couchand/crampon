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
    @values.push val unless @values.indexOf val

  getChild: (name) ->
    if @children[name]?
      @children[name].plural on
    else
      @children[name] = new NodeType name

analyze = (et, continuing) ->
  root = new NodeType 'root'
  root.children = continuing if continuing?
  analyzeNode root, et
  root.children

analyzeNode = (parent_type, node) ->
  children = node.getchildren()
  this_type = parent_type.getChild node.tag

  if children.length is 0
    this_type.addValue node.text
  else
    for child in children
      analyzeNode this_type, child

module.exports = analyze
