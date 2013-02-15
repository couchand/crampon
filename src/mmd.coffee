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
    name = node.tag
    if @children[name]?
      @children[name].plural on
    else
      @children[name] = new NodeType node
    @children[name]

  analyze: (node) ->
    children = node.getchildren()
    if children.length is 0
      @addValue node.text
    else
      @getChild(child).analyze child for child in children

analyze = (et) ->
  root = new NodeType et
  root.analyze et
  root

module.exports = analyze
