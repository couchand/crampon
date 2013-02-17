# json to coffee compiler
# builds a parser for xml from its inferred structure

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

make_builder = (name, node) ->
  indent = "      "
  builder = builderize name
  "#{indent}when '#{name}'\n#{indent}  Builder = #{builder}"

builders = (nodes) ->
  (make_builder name, node for name, node of nodes).join '\n'

factory = (inodes, leaves) ->
  """
  #{header()}
  #{builders(inodes)}
  #{footer()}
  """

compile = (dicts) ->
  factory(dicts.inodes, dicts.leaves)

module.exports =
  compile: compile
