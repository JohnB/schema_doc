require 'spec/spec_helper'
require 'spec/schema_doc_spec_helper'


describe SchemaDoc do

  it "should provide a path to its YAML file" do
    SchemaDoc.persistent_file_path.should_not be_nil
  end
  
  it "should allow its YAML path to be set" do
    original = SchemaDoc.persistent_file_path
    SchemaDoc.persistent_file_path = 'whatever'
    SchemaDoc.persistent_file_path.should == 'whatever'    
    SchemaDoc.persistent_file_path = original  # set it back for other tests
  end
  
  it "should provide a path to its temp dir" do
    SchemaDoc.temp_dir.should_not be_nil
  end
  
  it "should allow its temp dir to be set" do
    original = SchemaDoc.temp_dir
    SchemaDoc.temp_dir = 'whatever'
    SchemaDoc.temp_dir.should == 'whatever'
    SchemaDoc.temp_dir = original  # set it back for other tests
  end
  
  it "should create a file when given an empty hash" do
    verify_file_is_created(SchemaDoc.persistent_file_path) do
      SchemaDoc.save({:id => 'SchemaDocSpecBelongsTo', :fields => {"col1a" => "value1a", "col2a" => "value2a#{rand}"}})
    end
  end
  
  it "should update the file when given new table data" do
    verify_file_is_changed(SchemaDoc.persistent_file_path) do
      SchemaDoc.save({:id => 'SchemaDocSpecHasOne', :fields => {"col1" => "value1", "col2" => "value2#{rand}"}})
    end
  end
  
  it "should collect a list of ActiveRecord model names" do
    SchemaDoc.model_names.should_not be_empty
  end
  
  it "should collect a hash of model relations" do
    SchemaDoc.relations_hash.should_not be_empty
  end
  
  it "should collect an inverse hash of model relations" do
    SchemaDoc.inverse_relations_hash.should_not be_empty
  end
  
  it "should provide graphviz DOT models" do
    SchemaDoc.dot_models.should_not be_empty
  end
  
  it "should provide graphviz DOT linkages" do
    SchemaDoc.dot_linkages.should_not be_empty
  end
  
  it "should provide graphviz DOT data" do
    SchemaDoc.dot_data.should_not be_empty
  end
  
  it "should provide a path to its DOT data file" do
    SchemaDoc.dot_data_file_path.should_not be_nil
  end
  
  it "should create the DOT file when requested" do
    verify_file_is_created(SchemaDoc.dot_data_file_path) do
      SchemaDoc.create_dot_file
    end
  end
  
  it "should create the index SVG file when requested" do
    verify_file_is_created(SchemaDoc.svg_data_file_path) do
      SchemaDoc.create_svg_file
    end
  end
  
  it "should create a specific-table's SVG file when requested" do
    verify_file_is_created(SchemaDoc.svg_data_file_path("SchemaDocSpecBelongsTo")) do
      SchemaDoc.create_svg_file("SchemaDocSpecBelongsTo")
    end
  end
  
end
