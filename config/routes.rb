Rails.application.routes.draw do
  root 'uploads#index'

  get 'search', controller: :uploads
  get 'ascii', controller: :uploads

  resources :uploads
  resources :tags
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
