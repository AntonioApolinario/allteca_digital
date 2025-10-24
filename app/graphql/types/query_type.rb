# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Materials queries
    field :materials, Types::MaterialType.connection_type, null: false, description: "Get all materials with filtering and pagination" do
      argument :search, String, required: false, description: "Search in title, description or author name"
      argument :status, String, required: false, description: "Filter by status"
      argument :material_type, String, required: false, description: "Filter by material type"
    end

    field :material, Types::MaterialType, null: true, description: "Get a single material by ID" do
      argument :id, ID, required: true, description: "ID of the material"
    end

    # Authors queries
    field :authors, [Types::AuthorType], null: false, description: "Get all authors" do
      argument :search, String, required: false, description: "Search in author name"
      argument :author_type, String, required: false, description: "Filter by author type"
    end

    field :author, Types::AuthorType, null: true, description: "Get a single author by ID" do
      argument :id, ID, required: true, description: "ID of the author"
    end

    # Users queries (apenas para usuário autenticado)
    field :me, Types::UserType, null: true, description: "Get current user information"

    # Resolvers
    def materials(search: nil, status: nil, material_type: nil)
      materials = Material.all
      materials = materials.search(search) if search.present?
      materials = materials.where(status: status) if status.present?
      materials = materials.where(type: material_type) if material_type.present?
      materials.order(created_at: :desc)
    end

    def material(id:)
      Material.find_by(id: id)
    end

    def authors(search: nil, author_type: nil)
      authors = Author.all
      authors = authors.where("name ILIKE ?", "%#{search}%") if search.present?
      authors = authors.where(type: author_type) if author_type.present?
      authors.order(created_at: :desc)
    end

    def author(id:)
      Author.find_by(id: id)
    end

    def me
      context[:current_user]
    end
  end
end
