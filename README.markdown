schema_doc
==========
SchemaDoc adds a few pages to your development-mode Rails app to view 
and document your database schema - both its table relationships and
the meanings of table columns.


Overview
--------
Once installed, accessing `yourRailsApp/schema_doc` will display a
[graphviz][0]-created directed graph of all your models and their
relationships to each other (similar to what the [railroad gem][1]
provides).

Clicking on one of the models will display the local graph around
that model (at `yourRailsApp/schema_doc/model`) along with a list
of the table attributes, their datatype, and whatever comments you
have added about the attribute. Your comments are persisted in the
`config/schema_doc_development.yml` file for committing to source
control.


Installing SchemaDoc
--------------------
  $ gem install schema_doc

#### Dependencies
* The Graphviz `dot` program must be in your path. Install it from [here][0].
* `sed` must be in your path (to work around a Graphviz issue)


#### Other Details
* Temporary DOT files and SVG files are stored in the public/images directory


ToDo Items
----------
* Improve the page styling


Meta
----
* Code: `git clone git://github.com/JohnB/schema_doc.git`
* Home: <http://github.com/JohnB/schema_doc>
* Bugs: <http://github.com/JohnB/schema_doc/issues>


Author
------

John Baylor :: john.baylor@gmail.com :: @JohnB

[0]: http://www.graphviz.org/
[1]: http://railroad.rubyforge.org/
