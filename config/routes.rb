Rails.application.routes.draw do
  root to: "admin/pets#index"
  resource :session
  resources :passwords, param: :token
  resources :locales, only: :update
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      post "signup", to: "users#create"
      delete "logout", to: "sessions#destroy"

      get "profile", to: "users#show"
      put "profile", to: "users#update"
      patch "profile", to: "users#update"
      delete "profile", to: "users#destroy"

      resources :pets, only: %i[index show]
      resources :shelters, only: %i[index show]
      resources :adoption_applications, only: %i[index create update destroy]
      resources :favorites, only: %i[index create destroy]
      resources :breeds, only: :index
      resources :cities, only: :index
    end
  end

namespace :admin do
  root to: "pets#index"

  resources :users
  resources :shelters
  resources :cities, except: %i[show]
  resources :breeds, except: %i[show]
  resources :adoption_applications, only: %i[index show edit update]

  resources :pets do
    resources :medical_records, only: %i[new create]
  end
  resources :medical_records, only: %i[index show edit update destroy]
  resources :breeds, only: %i[index create destroy]
  resources :cities, only: %i[index create destroy]
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
