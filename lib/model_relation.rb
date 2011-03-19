=begin
  model_relation.rb
  
  Define ModelRelation class for assisting the SchemaDoc class with ferreting out all the related models.
  
=end

class ModelRelation
  attr_accessor :model_name
  
  def initialize(m_name)
    @model_name = m_name
  end
  
  def model
    @model_name.constantize
  end
  
  def related_model_names
    model.reflect_on_all_associations.collect do |c|
      # An apparent association doesn't always link to a class - just ignore them
      begin
        # only use the "belongs_to" side of the relation so we clearly show the correct direction
        c.belongs_to? ? c.class_name.constantize.to_s : nil
      rescue => e
        nil     # ignore this one
      end
    end.compact.uniq # get rid of the ignored ones
  end
  
  def reverse_relations
    model.reflect_on_all_associations.collect do |c|
      # An apparent association doesn't always link to a class - just ignore them
      begin
        # treat a "NOT-belongs_to" relation as a has_N relation
        c.belongs_to? ? nil : c.class_name.constantize.to_s
      rescue => e
        nil     # ignore this one
      end
    end.compact.uniq # get rid of the ignored ones
  end
  
end
