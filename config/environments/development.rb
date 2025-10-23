Rails.application.configure do
  config.eager_load = false
  config.consider_all_requests_local = true
end

# Permitir todos os hosts em desenvolvimento para testes Swagger
