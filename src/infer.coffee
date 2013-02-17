# metadata inference

class NodeType
  constructor: (node) ->
    @name = node.name
    @isPlural = node.isPlural
  isLeaf: -> @values.length > 0
  isInode: -> @values.length is 0

class LeafType extends NodeType
  constructor: (node) ->
    super node
    @values = []
    @addValue val for val in node.values
  addValue: (val) ->
    @values.push val unless @values.indexOf(val) > -1

class InodeType extends NodeType
  constructor: (node) ->
    super node
    @children = []
    @addChild child for name, child of node.children
  addChild: (node) ->
    @children.push node.name unless @children.indexOf(node.name) > -1

class NodeWalker
  constructor: (node) ->
    @node = node

  get_inodes: (node) ->
    return [] if node.isLeaf()
    inodes = [node]
    for name, child of node.children
      child_inodes = @get_inodes child
      inodes.push.apply inodes, child_inodes if child_inodes.length
    inodes

  get_leaves: (node) ->
    return [node] if node.isLeaf()
    leaves = []
    for name, child of node.children
      child_leaves = @get_leaves child
      leaves.push.apply leaves, child_leaves if child_leaves.length
    leaves

  merge: (left, right) ->
    throw new Error "cannot merge nodes of different types: #{left.name}, #{right.name}" if left.name isnt right.name
    left.isPlural = left.isPlural or right.isPlural

  merge_leaf: (left, right) ->
    @merge left, right
    left.addValue value for value in right.values
    left

  merge_inode: (left, right) ->
    @merge left, right
    left.addChild child for child in right.children

  reset_inodes: (node, dictionary) ->
    return if !@is_inode node
    for name, child of node.children
      node.children[name] = dictionary[name]

class Inferrer
  constructor: ->
    @inodes_by_name = {}
    @leaves_by_name = {}

  analyze: (d) ->
    n = new NodeWalker()
    for inode in n.get_inodes d
      if @inodes_by_name[inode.name]
        @inodes_by_name[inode.name] = n.merge_inode @inodes_by_name[inode.name], inode
      else
        @inodes_by_name[inode.name] = new InodeType inode
    for leaf in n.get_leaves d
      if @leaves_by_name[leaf.name]
        @leaves_by_name[leaf.name] = n.merge_leaf @leaves_by_name[leaf.name], leaf
      else
        @leaves_by_name[leaf.name] = new LeafType leaf

module.exports =
  Inferrer: Inferrer
  NodeType: NodeType
  NodeWalker: NodeWalker
