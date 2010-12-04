module SchemaDocHelper
  
  # Code from http://ianpurton.com/helper-to-display-rails-flash-messages
  def schema_doc_flash
      f_names = [:notice, :warning, :message]
      fl = ''

      for name in f_names
        if flash[name]
          fl = fl + "<div class=\"#{name}\">#{flash[name]}</div>"
        end
      flash[name] = nil;
    end
    return fl
  end
end
