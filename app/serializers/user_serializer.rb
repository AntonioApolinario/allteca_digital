class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :created_at, :updated_at

  # Não incluir a senha por segurança
  
  # Incluir contagem de materiais para contexto
  attribute :materials_count do |user|
    user.materials.count
  end
end
