Rails.application.routes.draw do |map|
  map.resources :schema_doc, :except => [:new, :create, :edit, :destroy]
end
