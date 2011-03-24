# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "schema_doc/version"
require "engine"

Gem::Specification.new do |s|
  s.name        = "schema_doc"
  s.version     = SchemaDoc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Baylor"]
  s.email       = ["john.baylor@gmail.com"]
  s.homepage    = "https://github.com/JohnB/schema_doc"
  s.summary     = %q{A dynamic version of the RailRoad gem, with annotated schema diagrams}
  s.description = %q{See a diagram of all your models and drill down into each one.}
  
  s.add_development_dependency "rspec"

  s.rubyforge_project = "schema_doc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.date = %q{2011-03-23}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
end
