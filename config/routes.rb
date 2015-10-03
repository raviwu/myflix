Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'application#front_page'

  get '/register', to: 'users#new'

  get '/sign_in', to: 'sessions#new', as: 'sign_in'

  get '/home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :sessions, only: [:new, :create]
end
