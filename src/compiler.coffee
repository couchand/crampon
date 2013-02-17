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

class_header = (builder) ->
  """
  # each tag type that has child nodes has a class
  # this is one top-level class
  class #{builder}
    constructor: ->
  """

named_elements_header = ->
  """
  # maps of child elements by their name
  # only elements that have themselves children
  # (and thus are classes)
  """

set_method_header = ->
  """
  # primary method for filling up data
    set: (field, value, tag) ->
      switch field
  """

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

make_child_map = (child) ->
  "    @#{child} = {}"

named_elements = (name, node) ->
  """
  #{named_elements_header()}
  """
  #{make_child_maps node}

make_class = (name, node) ->
  """
  #{class_header builderize name}
  #{named_elements name, node}
  """

classes = (inodes, leaves) ->
  (make_class name, node for name, node of inodes).join '\n'

compile = (dicts) ->
  """
  #{factory(dicts.inodes, dicts.leaves)}
  #{classes(dicts.inodes, dicts.leaves)}
  """

module.exports =
  compile: compile
