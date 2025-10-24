# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Material mutations
    field :create_material, Types::MaterialType, null: true, description: "Create a new material" do
      argument :input, Types::MaterialInputType, required: true
    end

    field :update_material, Types::MaterialType, null: true, description: "Update an existing material" do
      argument :id, ID, required: true
      argument :input, Types::MaterialInputType, required: true
    end

    field :delete_material, Boolean, null: true, description: "Delete a material" do
      argument :id, ID, required: true
    end

    # Author mutations
    field :create_author, Types::AuthorType, null: true, description: "Create a new author" do
      argument :input, Types::AuthorInputType, required: true
    end

    # Resolvers
    def create_material(input:)
      return nil unless context[:current_user]

      material_class = input[:type].constantize
      material = material_class.new(
        input.to_h.except(:type).merge(user: context[:current_user])
      )

      if material.save
        material
      else
        raise GraphQL::ExecutionError.new(
          "Failed to create material: #{material.errors.full_messages.join(', ')}"
        )
      end
    end

    def update_material(id:, input:)
      return nil unless context[:current_user]

      material = Material.find_by(id: id)
      return nil unless material

      # Verificar autorização
      unless material.user == context[:current_user]
        raise GraphQL::ExecutionError.new("Not authorized to update this material")
      end

      if material.update(input.to_h.except(:type))
        material
      else
        raise GraphQL::ExecutionError.new(
          "Failed to update material: #{material.errors.full_messages.join(', ')}"
        )
      end
    end

    def delete_material(id:)
      return false unless context[:current_user]

      material = Material.find_by(id: id)
      return false unless material

      # Verificar autorização
      unless material.user == context[:current_user]
        raise GraphQL::ExecutionError.new("Not authorized to delete this material")
      end

      material.destroy
      true
    end

    def create_author(input:)
      return nil unless context[:current_user]

      author_class = input[:type].constantize
      author = author_class.new(input.to_h.except(:type))

      if author.save
        author
      else
        raise GraphQL::ExecutionError.new(
          "Failed to create author: #{author.errors.full_messages.join(', ')}"
        )
      end
    end
  end
end
