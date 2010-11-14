schema_doc
==========

SchemaDoc adds a few pages to your development-mode Rails app to view 
and document your database schema.


Overview
--------
Once installed, accessing `yourRailsApp/schema_doc` will display a
[graphviz][0]-created directed graph of all your models an their
relationships to each other.

Clicking on one of the models will display the local graph around
that model (at `yourRailsApp/schema_doc/model`) along with as a list
of the table attributes, their datatype, and whatever comments you
have added about the attribute. Your comments are saved in the
`config/schema_doc_development.yml` file for committing to source
control.


Installing SchemaDoc
--------------------
#### Dependencies
SchemaDoc requires that the Graphviz `dot` program be in your path. 
Install it from [here][0].

#### Integration with Your Rails App

    $ git clone git://github.com/JohnB/schema_doc.git
    $ cd schema_doc
    $ ruby add_schema_doc_simlinks.rb `full_path_to_your_rails_app`

To see what it will do, just run it with no argument - it will show
the symlinks to be created and the one file (routes.rb) that would be 
modified if you gave it the path to your rails app.


ToDo Items
----------
* Create the add_schema_doc_simlinks.rb file
* Verify against a fresh rails app
* Check in the existing index-only code
* Refactor to enable per-model pages
* Create the per-model diagram and edit form


Meta
----

* Code: `git clone git://github.com/JohnB/schema_doc.git`
* Home: <http://github.com/JohnB/schema_doc>
* Bugs: <http://github.com/JohnB/schema_doc/issues>


Author
------

John Baylor :: john.baylor@gmail.com :: @JohnB

[0]: http://www.graphviz.org/
