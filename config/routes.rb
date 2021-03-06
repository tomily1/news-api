# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :heartbeat, controller: :heartbeat
  resource :healthcheck, controller: :health_check

  post '/login', to: 'authentication#login'
  post '/logout', to: 'authentication#logout'
  post 'admin/logout', to: 'authentication#logout'

  resource :user, only: :create

  resources :posts, only: %i[index show]

  namespace :admin do
    resource :authentication, only: :create do
      member do
        post :login
      end
    end

    resource :posts, only: :create
  end
end
