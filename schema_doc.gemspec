# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{schema_doc}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Baylor"]
  s.date = %q{2011-03-10}
  s.description = %q{descript of gem}
  s.email = %q{john.baylor@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "Gemfile",
    "Rakefile",
    "VERSION",
    "app/controllers/application_controller.rb",
    "app/controllers/schema_docs_controller.rb",
    "config/routes.rb",
    "lib/engine.rb",
    "lib/model_relation.rb",
    "lib/schema_doc.rb",
    "spec/lib/model_relation_spec.rb",
    "spec/lib/schema_doc_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/JohnB/schema_doc}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{summary of the gem}
  s.test_files = [
    "spec/lib/model_relation_spec.rb",
    "spec/lib/schema_doc_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_development_dependency(%q<activerecord>, ["~> 3.0.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_dependency(%q<activerecord>, ["~> 3.0.3"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<builder>, ["~> 2.1.2"])
    s.add_dependency(%q<activerecord>, ["~> 3.0.3"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
