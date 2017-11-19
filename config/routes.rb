Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  resources :ext_images do
  end
  resources :folders do

  end
  get '/folder', to: 'folders#show', as: 'folders_root'
  post '/ext_image/:id/destroy', to: 'ext_images#destroy', as: 'ext_image_delete'
end
