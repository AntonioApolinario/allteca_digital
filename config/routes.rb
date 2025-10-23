Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        sessions: "api/v1/sessions"
      }, defaults: { format: :json }
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
