class Material < ApplicationRecord
  belongs_to :user
  belongs_to :author
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :status, presence: true, inclusion: { in: %w[draft published archived] }
  
  # STI validation
  validates :type, presence: true, inclusion: { in: %w[Book Article Video] }
  
  scope :published, -> { where(status: "published") }
  scope :draft, -> { where(status: "draft") }
  scope :archived, -> { where(status: "archived") }
  
  # Search scope
  scope :search, ->(query) {
    if query.present?
      where("title ILIKE :q OR description ILIKE :q", q: "%#{query}%")
        .or(where(author_id: Author.where("name ILIKE :q", q: "%#{query}%").select(:id)))
    else
      all
    end
  }
  
  def self.types
    %w[Book Article Video]
  end
  
  def self.statuses
    %w[draft published archived]
  end
end
