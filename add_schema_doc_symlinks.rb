
class AddSymlinks
  def initialize(argv = [])
    @rails_root = argv[0] || "RAILS_ROOT"
    @links = symlinks
    if argv[0]
      link_files
    else
      usage
    end
    describe_routes_change
  end
  
  def usage(links = [])
    lines = [
      "USAGE: add_schema_doc_symlinks [path_to_your_rails_app]",
      "  Will create a set of symlinks from SchemaDoc to your rails app.",
      "  and describe how to change your routes.rb file",
      "",
      "EXAMPLE LINKS: ",
    ]
    @links.each do |link|
      lines << "  #{link}"
    end
    
    lines.each {|line| puts line}
  end
  
  def symlinks
    [
      symlink("app/controllers/schema_doc_controller.rb"),
      symlink("app/helpers/schema_doc_helper.rb"),
      symlink("app/models/model_relation.rb"),
      symlink("app/models/schema_doc.rb"),
      symlink("app/views/layouts/schema_doc.html.haml"),
      symlink("app/views/schema_doc"),
      symlink("spec/controllers/schema_doc_controller_spec.rb"),
      symlink("spec/models/model_relation_spec.rb"),
      symlink("spec/models/schema_doc_spec.rb"),
      symlink("spec/schema_doc_spec_helper.rb"),
    ]
  end
  
  def symlink(relative_path)
    "ln -fs #{File.join(Dir.pwd,relative_path)} #{File.join(@rails_root,relative_path)}"
  end
  
  def link_files
    @links.each do |link|
      begin
        puts link
        `#{link}`
      rescue => e
        puts "*** Exception adding link: #{e}\n"
      end
    end
  end
  
  def describe_routes_change
    [
      "",
      "Add these lines to your config/routes.rb file:",
      "  if ::Rails.env == 'development'",
      "    resources :schema_doc, :except => [:new, :create, :edit, :destroy]",
      "  end",
      "",
      "And add these lines to your Gemfile file:",
      "  group :development, :test do",
      "    gem 'rspec-rails', '>= 2.0'",
      "    gem 'haml'",
      "  end",
      "",
    ].each { |line| puts line }
  end
end

AddSymlinks.new(ARGV)
