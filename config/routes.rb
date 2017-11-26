Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'
  resources :ext_images do
  end
  resources :folders do

  end
  get '/folder', to: 'folders#show', as: 'folders_root'
  post '/ext_image/:group/destroy', to: 'ext_images#destroy', as: 'ext_image_delete'

  namespace :scanlet do
    resources :projects, only: [:index, :show]
    resources :groups, only: [:show]
    resources :translations, only: [:show, :new, :create]
    get '/groups/:group/add_scan', to: 'translations#new', as: 'add_scan_to_group'
  end
end
