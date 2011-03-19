require 'active_record.rb'
require 'model_relation.rb'

class TestParent < ActiveRecord::Base
  has_many :test_children
end
class TestChild < ActiveRecord::Base
  belongs_to :test_parent
end
class TestLoner < ActiveRecord::Base
end

describe ModelRelation do
  describe "#related_model_names" do
    it "should return an empty list for a loner model" do
      ModelRelation.new('TestLoner').related_model_names.should == []
    end
    it "should return a list of belongs_to relations" do
      ModelRelation.new('TestChild').related_model_names.should == ['TestParent']
    end
    it "should return an empty list for a model with no belongs_to associations" do
      ModelRelation.new('TestParent').related_model_names.should == []
    end
  end

  describe "#reverse_relations" do
    it "should return an empty list for a loner model" do
      ModelRelation.new('TestLoner').reverse_relations.should == []
    end
    it "should return a list of has_N relations" do
      ModelRelation.new('TestParent').reverse_relations.should == ['TestChild']
    end
    it "should return an empty list for a model with no has_N associations" do
      ModelRelation.new('TestChild').reverse_relations.should == []
    end
  end
end
