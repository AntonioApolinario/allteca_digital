class AuthorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :type, :name, :birth_date, :city, :created_at, :updated_at

  has_many :materials

  # Atributos específicos por tipo
  attribute :author_type do |author|
    author.type
  end
  
  attribute :is_person do |author|
    author.is_a?(Person)
  end
  
  attribute :is_institution do |author|
    author.is_a?(Institution)
  end

  attribute :materials_count do |author|
    author.materials.count
  end

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
