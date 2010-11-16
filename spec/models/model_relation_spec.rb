require 'spec/spec_helper'
require 'spec/schema_doc_spec_helper'

describe ModelRelation do
  
  it "should provide a model from a model_name" do
    ModelRelation.new('SchemaDocSpecBelongsTo').model.should_not be_nil
  end
  
  it "should provide a list of related (belongs_to) model names" do
    ModelRelation.new('SchemaDocSpecBelongsTo').related_model_names.should_not be_empty
  end
  
  it "Bbb should have no related models" do
    ModelRelation.new('SchemaDocSpecBelongsTo').related_model_names.should_not be_empty
    ModelRelation.new('SchemaDocSpecBelongsTo').reverse_related_model_names.should be_empty
  end
  
  it "Bbb should have a reverse-related model" do
    ModelRelation.new('SchemaDocSpecHasOne').reverse_related_model_names.should_not be_empty
    ModelRelation.new('SchemaDocSpecHasOne').related_model_names.should be_empty
  end
  
  it "Ccc should have no related or reverse-related models" do
    ModelRelation.new('SchemaDocSpecLonely').related_model_names.should be_empty
    ModelRelation.new('SchemaDocSpecLonely').reverse_related_model_names.should be_empty
  end  
  
  it "should NOT provide a list of has_N relations" do
    ModelRelation.new('SchemaDocSpecHasOne').related_model_names.should be_empty
  end
end
