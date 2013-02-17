# metadata inference

both = (left, right) ->
  all = {}
  all[k] = v for k, v of left
  all[k] = v for k, v of right
  all

class Inferrer
  constructor: (enum_threshold) ->
    @threshold = enum_threshold or 12
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
    inode = {}
    for child in node.children
      inode[child] = @src.all[child].isPlural
    inode
  inferType: (values) ->
    all = (val.trim() for val in values).join ''
    return 'boolean' if all.match /^(true|false)+$/
    return 'number' if all.match /^[0-9]+$/
    return 'enum' if values.length < @threshold
    'string'

module.exports =
  Inferrer: Inferrer
