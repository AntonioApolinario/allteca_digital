class Author < ApplicationRecord
  has_many :materials, dependent: :restrict_with_error
  
  validates :name, presence: true
  
  # STI validation
  validates :type, presence: true, inclusion: { in: %w[Person Institution] }
  
  def self.types
    %w[Person Institution]
  end
end
