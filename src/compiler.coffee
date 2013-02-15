# json to coffee compiler
# builds a parser for xml from its inferred structure

get_inodes = (node) ->
  return [] if node.isLeaf()
  inodes = [node]
  for name, child of node.children
    child_inodes = get_inodes child
    inodes.push.apply inodes, child_inodes if child_inodes.length
  inodes

compile = (node) ->
  inodes = get_inodes(node)

module.exports = compile
