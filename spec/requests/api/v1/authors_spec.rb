require 'swagger_helper'

RSpec.describe 'Api::V1::Authors', type: :request do
  path '/api/v1/authors' do
    get 'Lista autores' do
      tags 'Autores'
      produces 'application/json'

      response '200', 'Autores listados' do
        run_test!
      end
    end

    post 'Cria autor' do
      tags 'Autores'
      security [ bearerAuth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          type: { type: :string, enum: ['Person', 'Institution'] },
          name: { type: :string },
          birth_date: { type: :string, format: 'date' },
          city: { type: :string }
        },
        required: ['type', 'name']
      }

      response '201', 'Autor criado' do
        let(:Authorization) { 'Bearer token' }
        let(:author) { { type: 'Person', name: 'Autor Teste' } }
        run_test!
      end
    end
  end
end
