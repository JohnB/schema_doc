
class SchemaDocSpecBelongsTo < ActiveRecord::Base
  belongs_to :SchemaDocSpecHasOne
end
class SchemaDocSpecHasOne < ActiveRecord::Base
  has_one :SchemaDocSpecBelongsTo
end
class SchemaDocSpecLonely < ActiveRecord::Base
  # has no relations
end

RSpec.configure do |config|

  def verify_file_is_created(filepath)
    FileUtils.rm_f(filepath)
    yield
    puts "DEBUG: attempted to make #{filepath}" unless File.exists?(filepath)
    File.exists?(filepath).should be_true
  end
  
  def verify_file_is_changed(filepath)
    original = IO.read(filepath) rescue ""
    yield
    updated = IO.read(filepath) rescue ""
    updated.should_not == original
  end

end
