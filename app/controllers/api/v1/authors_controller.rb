class Api::V1::AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :update, :destroy]

  def index
    authors = policy_scope(Author).includes(:materials)
    render json: AuthorSerializer.new(authors).serializable_hash
  end

  def show
    render json: AuthorSerializer.new(@author).serializable_hash
  end

  def create
    authenticate_user!
    author = Author.new(author_params)
    authorize author
    
    if author.save
      render json: AuthorSerializer.new(author).serializable_hash, status: :created
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authenticate_user!
    authorize @author
    
    if @author.update(author_params)
      render json: AuthorSerializer.new(@author).serializable_hash
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authenticate_user!
    authorize @author
    @author.destroy
    head :no_content
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:type, :name, :birth_date, :city)
  end
end
