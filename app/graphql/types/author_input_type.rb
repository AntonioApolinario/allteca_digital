# frozen_string_literal: true

module Types
  class AuthorInputType < Types::BaseInputObject
    description "Input for creating authors"

    argument :type, String, required: true, description: "Author type (Person, Institution)"
    argument :name, String, required: true, description: "Author name"
    
    # Specific fields for each type
    argument :birth_date, GraphQL::Types::ISO8601Date, required: false, description: "Birth date for persons"
    argument :city, String, required: false, description: "City for institutions"
  end
end
