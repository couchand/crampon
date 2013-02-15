# json to coffee compiler
# builds a parser for xml from its inferred structure

get_inodes = (node) ->
  return [] if node.isLeaf()
  inodes = [node]
  for name, child of node.children
    child_inodes = get_inodes child
    inodes.push.apply inodes, child_inodes if child_inodes.length
  inodes

header = ->
  """
  # when a tag comes up with child nodes, decide which one
  # to create to hold those children
  class Factory
    build: (tag) ->
      switch tag.tag
  # note the class names are the tag names, but
  #  - capitalized
  #  - trailing 's' removed
  """

footer = ->
  '''
  # shouldn't happen if our training set is large
        else throw new Error "unknown tag type #{tag.tag}"

      thing = new Builder()

      tag.getchildren().forEach (child) ->
        thing.set child.tag, child.text, child

  # this is a particular special case...
      thing.finishBuild() if thing.finishBuild
      thing

  factory = new Factory()
  '''

builderize = (tag_name) ->
  singular = tag_name.replace /s$/, ''
  singular[0].toUpperCase() + singular[1..]

make_builder = (node) ->
  indent = "      "
  field = node.tag
  builder = builderize field
  "#{indent}when '#{field}'\n#{indent}  Builder = #{builder}"

builders = (nodes) ->
  (make_builder node for node in nodes).join '\n'

factory = (nodes) ->
  """
  #{header()}
  #{builders(nodes)}
  #{footer()}
  """

compile = (node) ->
  inodes = get_inodes(node)
  factory(inodes)

module.exports =
  compile: compile
