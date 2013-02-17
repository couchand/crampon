# metadata inference

class Inode
  constructor: ->
    @children = {}

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
    @out.leaves[name] = @inferType node.values for name, node of @src.leaves
    @out
  buildInode: (node) ->
    inode = new Inode()
    for child in node.children
      inode.children[child] = @src.all[child].isPlural
    inode
  inferType: (values) ->
    'string'

module.exports =
  Inode: Inode
  Inferrer: Inferrer
