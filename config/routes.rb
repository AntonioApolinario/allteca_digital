Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      
      # Resources
      resources :materials, only: [:index, :show, :create, :update, :destroy]
      resources :authors, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
