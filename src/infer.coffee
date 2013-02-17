# metadata inference

class Inode
  constructor: ->
    @children = {}

class Leaf
  constructor: (@type) ->

both = (left, right) ->
  all = {}
  all[k] = v for k, v of left
  all[k] = v for k, v of right
  all

class Inferrer
  analyze: (dictionaries) ->
    @src = dictionaries
    @src.all = both @src.inodes, @src.leaves
    @out =
      inodes: {}
      leaves: {}
    @out.inodes[name] = @buildInode node for name, node of @src.inodes
    @out.leaves[name] = @buildLeaf node for name, node of @src.leaves
    @out
  buildInode: (node) ->
    inode = new Inode()
    for child in node.children
      inode.children[child] = @src.all[child].isPlural
    inode
  buildLeaf: (node) ->
    new Leaf @inferType node.values
  inferType: (values) ->
    'string'

module.exports =
  Inode: Inode
  Leaf: Leaf
  Inferrer: Inferrer
