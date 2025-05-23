Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#index'

  resources :doctors, only: [:index, :show] do
    collection do
      get :search
    end
    resources :appointments, only: [:new, :create]
  end

  resources :hospitals, only: [:index, :show]

  resources :appointments, only: [:index, :show, :edit, :update, :destroy]

  resources :availabilities, except: [:show]

  get 'dashboard', to: 'dashboards#show'

  # API endpoints for maps
  namespace :api do
    namespace :v1 do
      get 'doctors/nearby', to: 'doctors#nearby'
      get 'hospitals/nearby', to: 'hospitals#nearby'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
