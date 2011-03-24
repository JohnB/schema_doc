# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'controllers'))
# $LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'config'))

require 'rails'
require 'active_model.rb'
require 'action_view.rb'

# require 'active_record.rb'
# require 'schema_doc.rb'
require 'action_controller'
# require 'application_controller.rb'
# require "schema_docs_controller.rb"

require 'rspec/rails'
require 'fileutils'
include FileUtils

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # config.include RSpec::Rails::ControllerExampleGroup
end

def expect_dot_contents path, expected_hash, not_expected_list = []
  File.exists?(path).should be_true "nonexistent #{path}"
  file_data = IO.read(path)
  expected_hash.each do |from, to|
    label = "label = \"#{from}\""
    file_data.should =~ Regexp.new(label)
    if to
      label = "label = \"#{to}\""
      file_data.should =~ Regexp.new(label)
      linkage = "\"#{from}\"->\"#{to}\""
      file_data.should =~ Regexp.new(linkage)
    end
  end
  not_expected_list.each do |table|
    file_data.should_not =~ Regexp.new(table)
  end
end

def full_schema_paths
  [SchemaDoc.full_schema_svg_path, SchemaDoc.connected_schema_svg_path]
end

# wrapper for tests that should create files
def verify_file_creation list_of_files
  list_of_files.each do |path|
    rm_rf path
    File.exists?(path).should be_false        
  end
  yield
  list_of_files.each do |path|
    File.exists?(path).should be_true        
  end
end

