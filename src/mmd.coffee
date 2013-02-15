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
    @values.push val unless @values.indexOf val > -1

  getChild: (name) ->
    if @children[name]?
      @children[name].plural on
    else
      @children[name] = new NodeType name
    @children[name]

analyze = (et) ->
  root = new NodeType 'root'
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
