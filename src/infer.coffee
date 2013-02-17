# metadata inference

class NodeType
  constructor: (name) ->
    @name = name

class Inode extends NodeType
  constructor: (name) ->
    super name
    @children = {}

class Leaf extends NodeType
  constructor: (name) ->
    super name

both = (left, right) ->
  all = {}
  all[k] = v for k, v of left
  all[k] = v for k, v of right
  all

class Inferrer
  analyze: (dictionaries) ->
    @src = dictionaries
    @src.all = both @src.inodes, @src.leaves
    @inodes = (@buildInode node for name, node of @src.inodes)
    @leaves = (@buildLeaf node for name, node of @src.leaves)
    { inodes: @inodes, leaves: @leaves }
  buildInode: (node) ->
    inode = new Inode node.name
    for child in node.children
      inode.children[child] = @src.all[child].isPlural
    inode
  buildLeaf: (node) ->
    leaf = new Leaf node.name
    leaf.type = @inferType node.values
    leaf
  inferType: (values) ->
    'string'

module.exports =
  Inode: Inode
  Leaf: Leaf
  Inferrer: Inferrer
