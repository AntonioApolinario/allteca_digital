class AuthorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :type, :name, :birth_date, :city, :created_at, :updated_at

  has_many :materials
end
