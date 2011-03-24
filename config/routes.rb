Rails.application.routes.draw do |map|
  map.resources :schema_docs, :except => [:new, :create, :edit, :destroy]
end
