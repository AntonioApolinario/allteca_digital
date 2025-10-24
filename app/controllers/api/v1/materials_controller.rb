class Api::V1::MaterialsController < ApiController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_material, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: [:index, :search]

  # GET /api/v1/materials
  def index
    materials = policy_scope(Material)
                .includes(:author, :user)
                .order(created_at: :desc)
    
    # Paginação com Kaminari
    materials = materials.page(params[:page]).per(params[:per_page] || 20)
    
    render json: {
      materials: MaterialSerializer.new(materials).serializable_hash,
      pagination: {
        current_page: materials.current_page,
        total_pages: materials.total_pages,
        total_count: materials.total_count,
        per_page: materials.limit_value
      }
    }
  end

  # GET /api/v1/materials/search?q=termo
  def search
    materials = policy_scope(Material)
                .search(params[:q])
                .includes(:author, :user)
                .order(created_at: :desc)
    
    materials = materials.page(params[:page]).per(params[:per_page] || 20)
    
    render json: {
      materials: MaterialSerializer.new(materials).serializable_hash,
      pagination: {
        current_page: materials.current_page,
        total_pages: materials.total_pages,
        total_count: materials.total_count,
        per_page: materials.limit_value
      }
    }
  end

  # GET /api/v1/materials/:id
  def show
    authorize @material
    render json: MaterialSerializer.new(@material).serializable_hash
  end

  # POST /api/v1/materials
  def create
    @material = Material.new(material_params)
    @material.user = current_user
    
    authorize @material

    if @material.save
      render json: MaterialSerializer.new(@material).serializable_hash, status: :created
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/materials/:id
  def update
    authorize @material

    if @material.update(material_params)
      render json: MaterialSerializer.new(@material).serializable_hash
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/materials/:id
  def destroy
    authorize @material
    @material.destroy
    head :no_content
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(
      :type, :title, :description, :status, :author_id,
      :isbn, :page_count, :doi, :duration_minutes
    )
  end
end
