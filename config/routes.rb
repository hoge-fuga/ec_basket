Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  get 'manual_new_item', to: 'items#manual_new'
  
  resources :users, only: [:show, :new, :create, :update, :edit, :destroy]
  resources :items, only: [:new, :create, :destroy, :update, :edit]
  
  post 'api/item_create', to: 'api#item_create'
end