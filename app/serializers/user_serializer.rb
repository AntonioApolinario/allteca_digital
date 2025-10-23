class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :created_at, :updated_at

  # Não incluir a senha por segurança
end
