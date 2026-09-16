Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  namespace :api do
    namespace :v1 do
      get "sessions/create"
      get "sessions/destroy"
      get "adoption_applications/create"
      get "adoption_applications/index"
      get "pets/index"
      get "pets/show"
    end
  end
  namespace :admin do
    root to: "pets#index"

    # Refugios (CRUD completo para Admin Global)
    resources :shelters

    # Solicitudes de Adopción (Revisión y actualización de estado)
    resources :adoption_applications, only: %i[index show edit update]

    # Mascotas y su ruteo anidado
    resources :pets do
      # Ruta anidada únicamente para crear registros médicos en el contexto de una mascota
      resources :medical_records, only: %i[new create]
    end

    # Registros médicos independientes (Listar, ver, editar, actualizar, eliminar)
    resources :medical_records, only: %i[index show edit update destroy]
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
