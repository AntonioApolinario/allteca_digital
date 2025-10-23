class Api::V1::BooksController < ApplicationController
  before_action :authenticate_user!
  
  def create_with_isbn
    isbn = params[:isbn]&.gsub(/\D/, '') # Remove não-dígitos
    
    unless isbn&.match?(/\A\d{13}\z/)
      return render json: { error: "ISBN deve conter 13 dígitos" }, status: :unprocessable_entity
    end
    
    # Verifica se livro já existe
    if Book.exists?(isbn: isbn)
      return render json: { error: "Livro com este ISBN já existe" }, status: :unprocessable_entity
    end
    
    # Busca dados na OpenLibrary
    service = OpenLibraryService.new
    book_data = service.fetch_book_by_isbn(isbn)
    
    unless book_data
      return render json: { error: "ISBN não encontrado na OpenLibrary" }, status: :not_found
    end
    
    # Cria o livro
    book = Book.new(
      isbn: isbn,
      title: book_data[:title],
      page_count: book_data[:page_count],
      user: current_user,
      status: 'rascunho'
    )
    
    # Autor é obrigatório - precisa ser criado ou selecionado
    if params[:author_id]
      book.author = Author.find(params[:author_id])
    else
      # Cria autor padrão ou usa lógica específica
      return render json: { error: "Autor é obrigatório" }, status: :unprocessable_entity
    end
    
    if book.save
      render json: MaterialSerializer.new(book).serializable_hash, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
