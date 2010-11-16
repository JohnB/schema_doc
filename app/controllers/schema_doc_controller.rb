class SchemaDocController < ApplicationController
  MSG_CANCELED = "Changes canceled"
  MSG_SAVED = "Schema documentation updated"
  
  def index
    SchemaDoc.create_svg_file
  end

  def show
    @table_to_show = params[:id]
    # puts "ModelRelation.new(#{@table_to_show}).related_model_names"
    # puts ModelRelation.new(@table_to_show).related_model_names
    # puts "that was it?"
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
