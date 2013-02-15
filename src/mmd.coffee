# meta-metadata

class NodeType
  constructor: (node) ->
    @name = node.tag
    @isPlural = no
    @values = []
    @children = {}

  plural: ->
    @isPlural = yes

  isLeaf: -> @values.length > 0

  addValue: (val) ->
    @values.push val unless @values.indexOf(val) > -1

  getChild: (node) ->
    name = node.tag
    if @children[name]?
      @children[name].plural on
    else
      @children[name] = new NodeType node
    @children[name]

analyze = (et) ->
  root = new NodeType et
  analyzeNode root, et
  root

analyzeNode = (this_type, node) ->
  children = node.getchildren()

  if children.length is 0
    this_type.addValue node.text
  else
    analyzeNode this_type.getChild(child), child for child in children

module.exports = analyze
