class Api::V1::MaterialsController < ApplicationController
  # Temporariamente sem autenticação para testes
  before_action :set_material, only: [:show, :update, :destroy]

  def index
    materials = Material.includes(:author, :user)
                .search(params[:q])
                .order(created_at: :desc)
                .page(params[:page]).per(params[:per_page] || 10)
    
    render json: {
      data: MaterialSerializer.new(materials).serializable_hash,
      pagination: {
        current_page: materials.current_page,
        total_pages: materials.total_pages,
        total_count: materials.total_count,
        per_page: materials.limit_value
      }
    }
  end

  def show
    render json: MaterialSerializer.new(@material).serializable_hash
  end

  def create
    # Usar primeiro usuário disponível
    user = User.first
    material = Material.new(material_params)
    material.user = user
    
    if material.save
      render json: MaterialSerializer.new(material).serializable_hash, status: :created
    else
      render json: { errors: material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @material.update(material_params)
      render json: MaterialSerializer.new(@material).serializable_hash
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @material.destroy
    head :no_content
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:type, :title, :description, :status, :author_id, 
                                    :isbn, :page_count, :doi, :duration_minutes)
  end
end
