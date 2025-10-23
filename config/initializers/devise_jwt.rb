Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { Rails.application.credentials.secret_key_base }
    jwt.expiration_time = 30.days.to_i
  end
end
