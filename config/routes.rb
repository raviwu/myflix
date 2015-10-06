Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'application#front_page'

  get '/register', to: 'users#new'

  get '/sign_in', to: 'sessions#new', as: 'sign_in'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'

  get '/home', to: 'videos#index'
  get '/my_queue', to: 'queue_items#index'

  put '/update_queue_position', to: 'queue_items#update_position'
  patch '/update_queue_position', to: 'queue_items#update_position'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
    member do
      post 'review', to: 'videos#create_review'
      post 'add_queue', to: 'queue_items#create'
    end
  end

  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :sessions, only: [:new, :create]
  resources :queue_items, only: [:destroy]
end
