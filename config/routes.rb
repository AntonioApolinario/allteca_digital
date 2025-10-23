Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      
      # Devise routes (manter para compatibilidade)
      devise_for :users, controllers: {
        sessions: "api/v1/sessions"
      }, defaults: { format: :json }, skip: [:sessions]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
