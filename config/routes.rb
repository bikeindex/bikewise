require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: "users/registrations", sessions: "users/sessions" }

  resources :users, only: [:edit, :update]
  resources :account, only: [:index, :edit, :update]
  root "welcome#index"
  get "developer", to: "welcome#developer"

  resources :documentation, only: [:index] do
    collection do
      get :api_v1
      get :api_v2
    end
  end

  mount API::Base => "/api"

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
