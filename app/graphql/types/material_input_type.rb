# frozen_string_literal: true

module Types
  class MaterialInputType < Types::BaseInputObject
    description "Input for creating/updating materials"

    argument :type, String, required: true, description: "Material type (Book, Article, Video)"
    argument :title, String, required: true, description: "Material title"
    argument :description, String, required: false, description: "Material description"
    argument :status, String, required: true, description: "Material status"
    argument :author_id, ID, required: true, description: "Author ID"
    
    # Specific fields for each type
    argument :isbn, String, required: false, description: "ISBN for books"
    argument :page_count, Integer, required: false, description: "Page count for books"
    argument :doi, String, required: false, description: "DOI for articles"
    argument :duration_minutes, Integer, required: false, description: "Duration for videos"
  end
end
