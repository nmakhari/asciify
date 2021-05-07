Rails.application.routes.draw do

  root 'uploads#index'

  get 'search', controller: :uploads
  get 'uploads/show'

  resources :uploads
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
