class Api::V1::MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :update, :destroy]

  def index
    materials = policy_scope(Material)
                .includes(:author, :user)
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
    authenticate_user!
    material = current_user.materials.build(material_params)
    authorize material
    
    if material.save
      render json: MaterialSerializer.new(material).serializable_hash, status: :created
    else
      render json: { errors: material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authenticate_user!
    authorize @material
    
    if @material.update(material_params)
      render json: MaterialSerializer.new(@material).serializable_hash
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authenticate_user!
    authorize @material
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
