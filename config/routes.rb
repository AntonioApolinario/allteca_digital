Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      get "auth/me", to: "auth#me"
      
      # Resources
      resources :materials, only: [:index, :show, :create, :update, :destroy]
      resources :authors, only: [:index, :show, :create, :update, :destroy]
      
      # Book specific routes
      post "books/isbn", to: "books#create_with_isbn"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
