class Api::V1::AuthorsController < ApiController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_author, only: [:show, :update, :destroy]
  after_action :verify_authorized, except: :index

  # GET /api/v1/authors
  def index
    authors = Author.all.order(created_at: :desc)
    
    # Paginação
    authors = authors.page(params[:page]).per(params[:per_page] || 20)
    
    render json: {
      authors: AuthorSerializer.new(authors).serializable_hash,
      pagination: {
        current_page: authors.current_page,
        total_pages: authors.total_pages,
        total_count: authors.total_count,
        per_page: authors.limit_value
      }
    }
  end

  # GET /api/v1/authors/:id
  def show
    authorize @author
    render json: AuthorSerializer.new(@author).serializable_hash
  end

  # POST /api/v1/authors
  def create
    @author = Author.new(author_params)
    authorize @author

    if @author.save
      render json: AuthorSerializer.new(@author).serializable_hash, status: :created
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/authors/:id
  def update
    authorize @author

    if @author.update(author_params)
      render json: AuthorSerializer.new(@author).serializable_hash
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/authors/:id
  def destroy
    authorize @author
    
    if @author.destroy
      head :no_content
    else
      render json: { errors: ["Não foi possível excluir o autor. Verifique se existem materiais vinculados."] }, status: :unprocessable_entity
    end
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(
      :type, :name, :birth_date, :city
    )
  end
end
