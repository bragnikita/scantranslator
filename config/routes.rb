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

  post '/uploads/common_images', to: 'common_uploads#common_image', as: 'common_images_upload'

  namespace :scanlet do
    resources :projects
    resources :groups do
      member do
        get 'translations'
      end
    end
    resources :translations, only: [:show, :new, :create]
    get '/groups/:group/add_scan', to: 'translations#new', as: 'add_scan_to_group'
  end
end
