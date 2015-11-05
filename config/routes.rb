require 'sidekiq/web'

Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'application#front_page'

  get '/register', to: 'users#new'
  resources :users, only: [:create, :show]
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/expired_invitation', to: 'invitations#expired', as: 'expired_invitation_token'

  get '/forgot_password', to: 'forgot_passwords#new'
  get '/confirm_password_reset', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  get '/expired_token', to: 'password_resets#expired'
  resources :password_resets, only: [:show, :create]

  get '/sign_in', to: 'sessions#new', as: 'sign_in'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'
  resources :sessions, only: [:create]

  get '/people', to: 'followships#index'
  resources :followships, only: [:destroy, :create]

  get '/my_queue', to: 'queue_items#index'
  put '/update_queue_position', to: 'queue_items#update_position'
  patch '/update_queue_position', to: 'queue_items#update_position'
  resources :queue_items, only: [:destroy]

  get '/invite', to: 'invitations#new'
  resources :invitations, only: [:create]

  get '/home', to: 'videos#index'
  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search'
      post 'advanced_search', to: 'videos#advanced_search'
    end
    member do
      post 'review', to: 'videos#create_review'
      post 'add_queue', to: 'queue_items#create'
    end
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine, at: '/stripe_events'

  resources :categories, only: [:show]

  mount Sidekiq::Web => '/sidekiq'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    user = ENV["SIDEKIQ_USERNAME"]
    password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?

end
