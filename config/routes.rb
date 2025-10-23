Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: "api/v1/sessions",
        registrations: "api/v1/registrations"
      }

      # Futuros endpoints aqui
      # resources :materials, only: [:index, :show, :create, :update, :destroy]
      # resources :authors, only: [:index, :show, :create]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
