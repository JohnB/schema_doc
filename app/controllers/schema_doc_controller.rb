class SchemaDocController < ApplicationController
  MSG_CANCELED = "Changes canceled"
  MSG_SAVED = "Schema documentation updated"
  
  layout 'schema_doc'
  
  def index
    SchemaDoc.create_svg_file
  end

  def show
    @table_to_show = params["id"]
    @columns = SchemaDoc.columns_to_document(@table_to_show).collect do |column|
      value = SchemaDoc[@table_to_show][column.name] || ""
      {:name => column.name,
       :datatype => column.type,
       :value => value,
       :size => [40,value.length].max
      }
    end
    SchemaDoc.create_svg_file(@table_to_show)
  end
  
  def update
    @table_to_show = params["id"]
    puts "Saving these params: #{params.inspect}"
    SchemaDoc.save(params.symbolize_keys)
    flash[:notice] = MSG_SAVED
    redirect_to :action => 'index'
  end

end
