Devise.setup do |config|
  config.jwt do |jwt|
    # Usar uma chave fixa para testes
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { "test_secret_key_1234567890" }
    jwt.expiration_time = 30.days.to_i
  end
end
