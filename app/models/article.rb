class Article < Material
  validates :doi, presence: true, uniqueness: true,
                  format: { with: /\A10\.\d{4,9}\/[-._;()\/:A-Z0-9]+\z/i, 
                            message: "must follow DOI format (10.1000/xyz123)" }
end
