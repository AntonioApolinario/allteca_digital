class Material < ApplicationRecord
  belongs_to :user
  belongs_to :author
  
  # Status em português conforme requisitos
  enum status: { rascunho: 'rascunho', publicado: 'publicado', arquivado: 'arquivado' }
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  
  # STI validation
  validates :type, presence: true, inclusion: { in: %w[Book Article Video] }
  
  # Scopes atualizados para português
  scope :published, -> { where(status: "publicado") }
  scope :draft, -> { where(status: "rascunho") }
  scope :archived, -> { where(status: "arquivado") }
  
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
    %w[rascunho publicado arquivado]
  end
end
