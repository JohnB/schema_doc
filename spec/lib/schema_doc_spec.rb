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

  describe "ensure_overview_images_exist" do
    it "should create full_schema and connected_schema files" do
      verify_file_creation full_schema_paths do
        SchemaDoc.ensure_overview_images_exist
      end
      expect_dot_contents SchemaDoc.full_schema_dot_path, {'TestChild'=>'TestParent','TestParent'=>nil,'TestLoner'=>nil}
    end
  end

  describe "ensure_subsection_exists" do
    it "should create specific child files" do
      svg_path = SchemaDoc.file(SchemaDoc.svg('TestChild'))
      dot_path = SchemaDoc.file(SchemaDoc.dot('TestChild'))
      verify_file_creation [dot_path, svg_path] do
        SchemaDoc.ensure_subsection_exists('TestChild')
      end
      expect_dot_contents dot_path, {'TestChild'=>'TestParent','TestParent'=>nil}, ['TestLoner']
    end

    it "should create specific parent files" do
      svg_path = SchemaDoc.file(SchemaDoc.svg('TestParent'))
      dot_path = SchemaDoc.file(SchemaDoc.dot('TestParent'))
      verify_file_creation [dot_path, svg_path] do
        SchemaDoc.ensure_subsection_exists('TestParent')
      end
      expect_dot_contents dot_path, {'TestChild'=>'TestParent','TestParent'=>nil}, ['TestLoner']
    end

    it "should create specific loner files" do
      svg_path = SchemaDoc.file(SchemaDoc.svg('TestLoner'))
      dot_path = SchemaDoc.file(SchemaDoc.dot('TestLoner'))
      verify_file_creation [dot_path, svg_path] do
        SchemaDoc.ensure_subsection_exists('TestLoner')
      end
      expect_dot_contents dot_path, {'TestLoner'=>nil}, ['TestChild','TestParent']
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
