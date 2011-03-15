require 'model_relation.rb'

class SchemaDoc
  ENV = ::Rails.env rescue 'test'
  ROOT = ::Rails.root.to_s rescue Dir.pwd
  PERSISTENCE_FILENAME = "schema_doc_#{ENV}.yml"
  DEFAULT_CONFIG_PATH = "#{ROOT}/config"
  PUBLIC_RELATIVE_TEMP_PATH = "images"
  DEFAULT_TEMP_PATH = "public/#{PUBLIC_RELATIVE_TEMP_PATH}"  # will be relative to ::Rails.root.to_s
  DOT_DOT = '.dot'
  DOT_SVG = '.svg'
  # DEFAULT_FILENAME = "schema_doc"
  # DOT_FILENAME = "schema_doc"+DOT_DOT
  # SVG_FILENAME = "schema_doc"+DOT_SVG
  DOT_APP_PATH = "/usr/local/bin/dot"

  class << self
    def all_model_names
      # Rails2: Object.subclasses_of( ActiveRecord::Base)
      # Rails3: ActiveRecord::Base.descendants
      @@all_model_names ||= ActiveRecord::Base.descendants.collect do |model|
        model.to_s rescue nil
      end.compact
    end
    
    def connected_model_names
      all_model_names.reject { |m| connected_models(m).empty? }
    end
    
    def ensure_overview_images_exist
      generate_full_schema unless File.exists?(full_schema_svg_path)
      generate_connected_schema unless File.exists?(connected_schema_svg_path)
    end
    
    def ensure_subsection_exists(model_name)
      generate_subsection(model_name) unless File.exists?(file(svg(model_name)))
    end
    
    def file_dir
      DEFAULT_TEMP_PATH
    end    
    def dot file_root
      file_root + DOT_DOT
    end
    def svg file_root
      file_root + DOT_SVG
    end
    def full_schema_dot_path
      file dot("full_schema")
    end
    def full_schema_svg_path
      file svg("full_schema")
    end
    def connected_schema_dot_path
      file dot("connected_schema")
    end
    def connected_schema_svg_path
      file svg("connected_schema")
    end
    def all_dot_files
      file dot("*")
    end
    def all_svg_files
      file svg("*")
    end
    def partial_schema_svg_path(model_name)
      file(svg(model_name))
    end
    def file filename
      File.join(file_dir, filename)
    end
    
    def connected_models(model_name)
      begin
        ModelRelation.new(model_name).related_model_names
      rescue Exception => e
        puts "#{__LINE__}: #{e}"
        []
      end
    end

    private
    def generate_full_schema
      generate_schema_diagram(full_schema_dot_path, full_schema_svg_path, :all_model_names)
    end
    
    def generate_connected_schema
      generate_schema_diagram(connected_schema_dot_path, connected_schema_svg_path, :connected_model_names)
    end
    
    def generate_subsection(model_name)
      generate_schema_diagram(file(dot(model_name)), file(svg(model_name)), :connected_model_names)
    end
    
    def generate_schema_diagram(dot_path, svg_path, method)
      create_dot_file(dot_path) do
        self.send(method).inject({}) do |memo, model_name|
          memo[model_name] = connected_models(model_name)
          memo
        end
      end
      convert_dot_file_to_svg_file(dot_path,svg_path)
    end
    
    def create_dot_file(dot_path)
      models = yield
      dot_models = models.keys.collect do |model_name|
        "\"#{model_name}\" [
            label = \"#{model_name}\"
            href = \"/schema_doc/#{model_name}\"
          ];"
      end.join("\n")
      dot_linkages = models.collect do |model_name,connected_models|
        # puts "#{model_name} => #{connected_models.inspect}"
        connected_models.collect {|relation| "\"#{model_name}\"->\"#{relation}\";"}
      end.flatten.join("\n")
            
      File.open(dot_path,"w") do |f| f.write("
        digraph \"SchemaDoc generated at #{Time.now}\"
        {
          node [
            fontsize = \"10\"
            shape = \"ellipse\"
          ];
          edge [
          ];
          #{dot_models}

          #{dot_linkages}
        }".gsub(/^\s*/,''))
      end
    end
    
    def convert_dot_file_to_svg_file(dot_file,svg_file)
      command = "cat #{dot_file} | #{DOT_APP_PATH} -Tsvg | sed 's/xlink:title/target=\"_top\" xlink:title/g' > #{svg_file}"
      run_command command
    end

    def run_command command
      # puts "Running command: '#{command}'"
      `#{command}`
    end
  end
end
