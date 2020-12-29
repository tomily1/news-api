# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :heartbeat, controller: :heartbeat
  resource :healthcheck, controller: :health_check

  post '/login', to: 'authentication#login'
  post '/logout', to: 'authentication#logout'

  resource :user, only: :create
end
