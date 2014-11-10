require 'sidekiq/web'
Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only: [:edit, :update]  
  root 'welcome#index'
  get 'developer', to: 'welcome#developer'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :incidents
      resources :locations, only: [:index]
      get '*a', to: 'api_v1#not_found'
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
