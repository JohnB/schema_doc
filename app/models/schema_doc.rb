
class SchemaDoc
  PERSISTENCE_FILENAME = "schema_doc_#{::Rails.env}.yml"
  DEFAULT_CONFIG_PATH = "#{::Rails.root.to_s}/config"
  PUBLIC_RELATIVE_TEMP_PATH = "images"
  DEFAULT_TEMP_PATH = "public/#{PUBLIC_RELATIVE_TEMP_PATH}"  # will be relative to ::Rails.root.to_s
  DEFAULT_FILENAME = "schema_doc"
  DOT_DOT = '.dot'
  DOT_SVG = '.svg'
  DOT_FILENAME = "schema_doc"+DOT_DOT
  SVG_FILENAME = "schema_doc"+DOT_SVG
  DOT_PATH = "/usr/local/bin/dot"
  
  class << self
    def persistent_file_path
      @@persistent_file_path ||= File.join(DEFAULT_CONFIG_PATH,PERSISTENCE_FILENAME)
    end
    
    def persistent_file_path= path
      @@persistent_file_path = path
    end
    
    def temp_dir
      @@temp_dir ||= DEFAULT_TEMP_PATH
    end
    
    def temp_dir= path
      @@temp_dir = path
    end
    
    def dot_path
      @@dot_path ||= DOT_PATH
    end
    
    def dot_path= path
      @@dot_path = path
    end
    
    def fix_for_filename( model_name )
      model_name.gsub(/\:/,'_')
    end
  
    def base_filename
      fix_for_filename(@@model_name || DEFAULT_FILENAME)
    end
    
    def dot_filename
      base_filename + DOT_DOT
    end
    
    def svg_filename
      base_filename + DOT_SVG
    end
    
    def dot_data_relative_file_path
      File.join(temp_dir, dot_filename)
    end
    
    def svg_data_relative_file_path
      File.join(temp_dir, svg_filename)
    end
    
    def full_temp_dir
      File.join(::Rails.root.to_s,temp_dir)
    end
    
    def dot_data_file_path
      File.join(::Rails.root.to_s,dot_data_relative_file_path)
    end
    
    def svg_data_file_path( model = nil )
      init( model )
      File.join(::Rails.root.to_s,svg_data_relative_file_path)
    end
    
    def schema_hash
      @@schema_hash ||= nil
      @@schema_hash ||= File.exists?(persistent_file_path) ? YAML.load_file(persistent_file_path) : {:tables => {}}
    end
    
    def save(hash)
      table_name = hash[:id]
      fields = hash[:fields] || {}
      if table_name
        schema_hash[:tables] ||= {}
        schema_hash[:tables][table_name] ||= {}
        schema_hash[:tables][table_name].merge!(fields)
      end
      File.open(persistent_file_path, "w") { |f| YAML.dump(schema_hash,f) }
      puts schema_hash.inspect
    end
    
    def force_model_loading
      Dir.glob("#{::Rails.root.to_s}/app/models/**/*.rb").each { |m| load(m) rescue nil }
    end
    
    def model_names
      @@models ||= begin
        force_model_loading
        # Rails2: Object.subclasses_of( ActiveRecord::Base)
        # Rails3: ActiveRecord::Base.descendants
        ActiveRecord::Base.descendants.collect do |model|
          model.model_name rescue nil
        end
      # rescue Exception => e
      #   puts "Something is very wrong: #{e}. #{e.backtrace}"
      end.compact
      
      @@model_name ||= nil
      if @@model_name
        # return the appropriate subset
        names = [@@model_name]
        names += relations_hash[@@model_name] if @@relations
        names
      else
        @@models
      end
    end
    
    def init( model_name )
      @@relations = nil if model_name
      @@model_name = model_name
    end
    
    def relations_hash
      @@relations ||= model_names.inject({}) do |memo,model_name|
        begin
          memo[model_name] = ModelRelation.new(model_name).related_model_names
          memo
        rescue Exception => e
          puts "Something is wrong: #{e}. #{e.backtrace}"
          memo
        end.inject({}) do |memo,name_and_relations|
          # Force the set to be unique
          memo[name_and_relations.first] = name_and_relations.last.uniq
          memo
        end
      end
      
    end
    
    def inverse_relations_hash
      hash_containing_dupes = relations_hash.inject({}) do |memo,name_and_relations|
        name_and_relations.last.each do |related_model_name|
          memo[related_model_name] ||= []
          memo[related_model_name] << name_and_relations.first
        end
        memo
      end
      
      # Force the set to be unique
      inverse_hash = hash_containing_dupes.inject({}) do |memo,name_and_relations|
        # puts "memo: #{memo.inspect}, name_and_relations: #{name_and_relations.inspect}."
        memo[name_and_relations.first] = name_and_relations.last.uniq
        memo
      end

      # # Get rid of forward-relations (assume we don't go both ways)
      inverse_hash.inject({}) do |memo,name_and_relations|
        # puts "memo: #{memo.inspect}, name_and_relations: #{name_and_relations.inspect}."
        memo[name_and_relations.first] = name_and_relations.last - (relations_hash[name_and_relations.first] || [])
        memo
      end
    end
    
    def dot_models
      model_names.collect do |model_name|
        "\"#{model_name}\" [
          label = \"#{model_name}\"
          href = \"/schema_doc/#{model_name}\"
          ];"
      end.join("\n")
    end
    def dot_linkages
      relations_hash.collect do |model_name,related_models|
        related_models.collect {|relation| "\"#{model_name}\"->\"#{relation}\";"}
      end.flatten.join("\n")
    end
  
    def dot_data
      @@dot_data ||= <<-DOT_DATA
        digraph "SchemaDoc generated at #{Time.now}"
        {
        node [
        fontsize = "10"
        shape = "ellipse"
        ];
        edge [
        ];
        #{dot_models}
      
        #{dot_linkages}
        }
      DOT_DATA
    end
    
    def svg_public_relative_file_path( model = nil )
      init( model )
      path = '/' + File.join(PUBLIC_RELATIVE_TEMP_PATH, svg_filename)
      puts "svg_public_relative_file_path(#{model}) => #{path}"
      path
    end
    
    def create_dot_file( model = nil )
      init( model )
      puts "create_dot_file(#{model}) => #{dot_data_file_path}"
      if File.exists?(dot_data_file_path)
        old_data = IO.read(dot_data_file_path)
        return if old_data == dot_data
      end
      FileUtils.mkdir_p(full_temp_dir)
      File.open(dot_data_file_path,"w") { |f| f.write(dot_data)}
    end
  
    def create_svg_file( model = nil )
      init( model )
      create_dot_file(model)
      command = "cat #{dot_data_file_path} | #{dot_path} -Tsvg > #{svg_data_file_path(model)}"
      puts "Running command: '#{command}'"
      `#{command}`
    end
  
  end  # end of class methods
end
