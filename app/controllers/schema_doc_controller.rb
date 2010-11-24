class SchemaDocController < ApplicationController
  MSG_CANCELED = "Changes canceled"
  MSG_SAVED = "Schema documentation updated"
  
  layout 'schema_doc'
  
  def index
    SchemaDoc.create_svg_file
  end

  def show
    @table_to_show = params["id"]
    SchemaDoc.create_svg_file(@table_to_show)
  end
  
  def update
    if params[:commit] == "Cancel"
      flash[:notice] = MSG_CANCELED
    else
      SchemaDoc.save(params)
      flash[:notice] = MSG_SAVED
    end
    redirect_to :action => 'index'
  end

end
