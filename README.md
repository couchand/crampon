crampon
=======

Get control of your Force.com metadata.

 * Introduction
 * Warning
 * Dependencies
 * Components
 * More Info

Introduction
------------

This library provides a simple facade for dealing with Force.com
metadata in JavaScript.  It currently supports loading most
object XML files.  Hopefully in the future it will support
other types of metadata, as well as other ways to load the
configuration such as pulling it directly from the server.

Assuming you have all your dependencies handled (a simple
`npm install` after checkout should do the trick), you can
go ahead and fire up the server with:

```bash
coffee src/server.coffee PRIOR CURRENT
```

Where `PRIOR` and `CURRENT` are directories containing
two versions of object metadata.  Perhaps you would execute:

```bash
coffee src/server.coffee production/src/objects staging/src/objects
```

Warning
-------

As always, the only true documentation is the code.

Dependencies
------------

 * CoffeeScript rules planet Earth

Components
----------

 * nodes - the node definitions
 * server - provide limited project navigation
 * loader - utility to load xml files
 * diff - utility to produce html output from difflet

More Info
---------

Did you know, the average GitHub README is never read to the bottom?
