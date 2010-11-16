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
    # puts "...  #{@model_name}: "
    model.reflect_on_all_associations.collect do |c|
      # An apparent association doesn't always link to a class - just ignore them
      begin
        # puts "#{c.class_name} "
        # only use the "belongs_to" side of the relation so we clearly show the correct direction
        c.belongs_to? ? c.class_name : nil
      rescue => e
        # puts " ----- EXCEPTION for [#{c.inspect}]: #{e}  ----- "
        nil     # ignore this one
      end
    end.compact.uniq # get rid of the ignored ones
  end
  
  def reverse_related_model_names
    SchemaDoc.inverse_relations_hash[@model_name] || []
  end
  
end
