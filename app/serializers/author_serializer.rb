class AuthorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :type, :name, :birth_date, :city, :created_at, :updated_at

  has_many :materials

  attribute :specific_attributes do |object|
    case object
    when Person
      { birth_date: object.birth_date }
    when Institution
      { city: object.city }
    else
      {}
    end
  end
end
