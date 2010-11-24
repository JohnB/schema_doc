require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../schema_doc_spec_helper')

describe SchemaDocController, :type => :controller do

  describe 'GET "index"' do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe 'GET "show"' do
    it "should be successful" do
      get 'show', :id => 'SchemaDocSpecBelongsTo'
      response.should be_success
    end
  end
  
  describe 'PUT "update"' do
    it "should accept cancel" do
      put 'update', :commit => "Cancel", :id => 'User'
      response.should redirect_to(schema_doc_index_url)
      flash[:notice].should have_text(SchemaDocController::MSG_CANCELED)
    end

    it "should accept save" do
      verify_file_is_changed(SchemaDoc.persistent_file_path) do
        post 'update', :commit => "Save", :id => 'SchemaDocSpecBelongsTo', :fields => {'login' => "random change (#{rand})"}
        response.should redirect_to(schema_doc_index_url)
        flash[:notice].should have_text(SchemaDocController::MSG_SAVED)
      end
    end
  end
  
end
