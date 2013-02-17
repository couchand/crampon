# meta-metadata

class NodeType
  constructor: (node) ->
    @name = node.tag
    @isPlural = no
    @values = []
    @children = {}

  plural: -> @isPlural = yes
  isLeaf: -> @values.length > 0

  addValue: (val) ->
    @values.push val unless @values.indexOf(val) > -1

  getChild: (node) ->
    @children[node.tag] ?= new NodeType node

  addChildren: (children) ->
    seen = {}
    for child_node in children
      child = @getChild child_node
      child.plural on if seen[child.name]
      seen[child.name] = yes
      child.analyze child_node

  analyze: (node) ->
    children = node.getchildren()
    if children.length is 0
      @addValue node.text
    else
      @addChildren children
    @

analyze = (et) ->
  new NodeType(et).analyze et

analyze.NodeType = NodeType

module.exports = analyze
