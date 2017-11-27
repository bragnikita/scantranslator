Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/folder')
  get "/sign_up", to: 'session#show'
  post "/sign_up", to: 'session#signup', as: 'signup'
  get 'logout', to: 'session#logout', as: 'logout'

  resources :ext_images do
  end
  resources :folders do
    get 'upload', on: :member
  end
  get '/folder', to: 'folders#show', as: 'folders_root'
  post '/ext_image/:id/destroy', to: 'ext_images#destroy', as: 'ext_image_delete'
end
