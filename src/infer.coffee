# metadata inference

mmd = require './mmd.coffee'

class NodeWalker
  constructor: (node) ->
    @node = node

  is_inode: (node) -> node.values.length is 0
  get_inodes: (node) ->
    return [] if !@is_inode node
    inodes = [node]
    for name, child of node.children
      child_inodes = @get_inodes child
      inodes.push.apply inodes, child_inodes if child_inodes.length
    inodes

  get_leaves: (node) ->
    return [node] if !@is_inode node
    inodes = []
    for name, child of node.children
      child_leaves = @get_leaves child
      inodes.push.apply inodes, child_leaves if child_leaves.length

  merge: (left, right) ->
    throw new Error 'cannot merge nodes of different types' if left.name isnt right.name
    combined = new mmd.NodeType left.name
    combined.isPlural = left.isPlural or right.isPlural
    combined

  merge_leaf: (left, right) ->
    combined = @merge left, right
    combined.addValue value for value in left.values
    combined.addValue value for value in right.values

  merge_inode: (left, right) ->
    combined = @merge left, right
    combined.children[child.name] = true for child in left.children
    combined.children[child.name] = true for child in right.children

  reset_inodes: (node, dictionary) ->
    return if !@is_inode node
    for name, child of node.children
      node.children[name] = dictionary[name]

class Inferrer
  constructor: ->
    @object_types = {}

  analyze: (xml) ->
    d = mmd xml
    n = new NodeWalker()
    inodes = n.get_inodes d
    inodes_by_name = {}
    for inode in inodes
      if inodes_by_name[inode.name]?
        inodes_by_name[inode.name] = merge inode, inodes_by_name[inode.name]
      else
        inodes_by_name[inode.name] = inode
    n.reset_inodes d, inodes_by_name
    d

module.exports =
  Inferrer: Inferrer
  NodeWalker: NodeWalker
