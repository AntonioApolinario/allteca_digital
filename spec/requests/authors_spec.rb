require 'rails_helper'

RSpec.describe 'Authors API', type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_jwt }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/authors' do
    before { create_list(:person, 3) }

    it 'returns all authors' do
      get '/api/v1/authors'
      
      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key('authors')
      expect(json_response).to have_key('pagination')
    end
  end

  describe 'POST /api/v1/authors' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          author: {
            type: 'Person',
            name: 'Test Author',
            birth_date: '1980-01-01'
          }
        }
      end

      it 'creates a new author' do
        post '/api/v1/authors', params: valid_attributes, headers: headers
        
        expect(response).to have_http_status(:created)
        expect(json_response['data']['attributes']['name']).to eq('Test Author')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          author: {
            type: 'Person',
            name: ''
          }
        }
      end

      it 'returns validation errors' do
        post '/api/v1/authors', params: invalid_attributes, headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /api/v1/authors/:id' do
    let(:author) { create(:person) }

    it 'returns the author' do
      get "/api/v1/authors/#{author.id}"
      
      expect(response).to have_http_status(:ok)
      expect(json_response['data']['attributes']['name']).to eq(author.name)
    end

    it 'returns not found for invalid id' do
      get '/api/v1/authors/invalid'
      
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /api/v1/authors/:id' do
    let(:author) { create(:person) }

    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          author: {
            name: 'Updated Name'
          }
        }
      end

      it 'updates the author' do
        put "/api/v1/authors/#{author.id}", params: valid_attributes, headers: headers
        
        expect(response).to have_http_status(:ok)
        expect(json_response['data']['attributes']['name']).to eq('Updated Name')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          author: {
            name: ''
          }
        }
      end

      it 'returns validation errors' do
        put "/api/v1/authors/#{author.id}", params: invalid_attributes, headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/authors/:id' do
    let(:author) { create(:person) }

    it 'deletes the author' do
      delete "/api/v1/authors/#{author.id}", headers: headers
      
      expect(response).to have_http_status(:no_content)
    end

    it 'returns error when author has materials' do
      create(:material, author: author)
      
      delete "/api/v1/authors/#{author.id}", headers: headers
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
