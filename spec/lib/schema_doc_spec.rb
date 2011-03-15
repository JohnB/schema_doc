require 'active_record.rb'
require 'fileutils'
require 'schema_doc.rb'
include FileUtils


describe SchemaDoc do
  before :all do
    eval('
      class TestParent < ActiveRecord::Base
        has_many :test_children
      end
      class TestChild < ActiveRecord::Base
        belongs_to :test_parent
      end
      class TestLoner < ActiveRecord::Base
      end
    ')
  end
  
  before :each do
    SchemaDoc.stub(:file_dir).and_return('/tmp')
  end
  
  describe "all_model_names" do
    it "should return names of all active-record models" do
      SchemaDoc.all_model_names.sort.should == %w[TestChild TestLoner TestParent]
    end
  end

  describe "ensure_overview_images_exist" do
    it "should create full_schema and connected_schema files" do
      paths = [SchemaDoc.full_schema_svg_path, SchemaDoc.connected_schema_svg_path]
      paths.each do |path|
        rm_rf path
        File.exists?(path).should be_false        
      end
      
      SchemaDoc.ensure_overview_images_exist

      paths.each do |path|
        File.exists?(path).should be_true "nonexistent #{path}"
      end
    end
  end

  describe "ensure_subsection_exists" do
    it "should create specific model files" do
      path = SchemaDoc.file(SchemaDoc.svg('child'))
      rm_rf path
      File.exists?(path).should be_false        
      
      SchemaDoc.ensure_subsection_exists('child')

      File.exists?(path).should be_true
    end
  end

  describe "file_dir" do
    it "should return a valid directory path" do
      dir = SchemaDoc.file_dir
      dir.should_not be_nil
      dir.should_not == ''
      Dir.exists?(dir).should == true
    end
  end

  describe "full_schema_svg_path" do
    it "should return a path" do
      path = SchemaDoc.full_schema_svg_path
      path.should_not be_nil
      path.should_not be_empty
    end
  end
  
  describe "full_schema_dot_path" do
    it "should return a path" do
      path = SchemaDoc.full_schema_dot_path
      path.should_not be_nil
      path.should_not be_empty
    end
  end
end
