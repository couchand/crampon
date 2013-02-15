# meta-metadata

class NodeType
  constructor: (name) ->
    @name = name
    @isPlural = no
    @values = []
    @children = {}

  plural: ->
    @isPlural = yes

  isLeaf: -> @values.length > 0

  addValue: (val) ->
    @values.push val unless @values.indexOf val > -1

  getChild: (name) ->
    if @children[name]?
      @children[name].plural on
    else
      @children[name] = new NodeType name
    @children[name]

analyze = (et) ->
  root = new NodeType et.tag
  analyzeNode root, et
  root

analyzeNode = (this_type, node) ->
  children = node.getchildren()

  if children.length is 0
    this_type.addValue node.text
  else
    analyzeNode this_type.getChild(child.tag), child for child in children

module.exports = analyze
