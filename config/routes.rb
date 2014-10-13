require 'sidekiq/web'
Rails.application.routes.draw do
  
  root 'welcome#index'
  get 'developers', to: 'welcome#developers'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :incidents
      resources :locations, only: [:index]
      get '*a', to: 'api_v1#not_found'
    end
  end

  # authenticate :user, lambda { |u| u.admin? } do
    # mount Sidekiq::Web => '/sidekiq'
  # end
end
