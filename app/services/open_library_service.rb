class OpenLibraryService
  BASE_URL = "https://openlibrary.org/api/books"
  
  def fetch_book_by_isbn(isbn)
    response = HTTParty.get("#{BASE_URL}?bibkeys=ISBN:#{isbn}&format=json&jscmd=data")
    
    if response.success?
      data = JSON.parse(response.body)["ISBN:#{isbn}"]
      return nil unless data
      
      {
        title: data["title"] || "Título não disponível",
        page_count: data["number_of_pages"] || 0,
        authors: data["authors"]&.map { |a| a["name"] } || []
      }
    else
      nil
    end
  rescue => e
    Rails.logger.error "OpenLibrary API Error: #{e.message}"
    nil
  end
end
