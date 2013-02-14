# test parsing xml

fs = require 'fs'
difflet = require 'difflet'
ent = require 'ent'

module.exports = (prev, next) ->
  tags =
    inserted: '<span class="g">'
    updated: '<span class="b">'
    deleted: '<span class="r">'
    comment: '<span class="c">'

  page = """
         <html>
           <body>
             <style>
               body { color: gray }
               .b { color: blue }
               .r { color: red }
               .g { color: green }
               .c { color: black }
             </style>
             <code><pre>
         """

  page += difflet({
    indent: 2
    comment: true
    start: (t, s) ->
      s.write tags[t]
    stop: (t, s) ->
      s.write '</span>'
    write: (buf, s) ->
      s.write ent.encode buf
  }).compare(prev, next)

  page += """
          </pre></code>
            </body>
          </html>
          """

  page
