require 'sidekiq/web'
Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only: [:edit, :update]
  root 'welcome#index'
  get 'developer', to: 'welcome#developer'

  resources :documentation, only: [:index]

  mount API::Base => '/api'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
