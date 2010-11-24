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
With Rails 3.1 this should become a Rails Engine but for now it is
"installed" into your app with a set of symlinks from the schema_doc
directory.

#### Dependencies
SchemaDoc requires that the Graphviz `dot` program be in your path. 
Install it from [here][0].

#### Integration with Your Rails App

    $ git clone git://github.com/JohnB/schema_doc.git
    $ cd schema_doc
    $ ruby add_schema_doc_symlinks.rb `full_path_to_your_rails_app`

To see what it will do, just run it with no argument - it will show
the symlinks to be created and the one file (routes.rb) that would be 
modified if you gave it the path to your rails app.


#### Other Details
* Temporary DOT files and SVG files are stored in the public/images directory


ToDo Items
----------
* Verify against a fresh rails app
* Refactor to enable per-model pages
* Create the per-model diagram and edit form
* Find a better way to integrate with a Rails app (such as a Rails 3.1 engine)


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
