class MaterialSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :type, :title, :description, :status, :created_at, :updated_at

  belongs_to :user
  belongs_to :author

  attribute :specific_attributes do |object|
    case object
    when Book
      { isbn: object.isbn, page_count: object.page_count }
    when Article
      { doi: object.doi }
    when Video
      { duration_minutes: object.duration_minutes }
    else
      {}
    end
  end
end
