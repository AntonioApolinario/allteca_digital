require 'swagger_helper'

RSpec.describe 'Api::V1::Authors', type: :request do
  let(:user) { create(:user) }

  path '/api/v1/authors' do
    get 'Lista autores' do
      tags 'Autores'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false, description: 'Página'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Itens por página'

      response '200', 'Autores listados' do
        before { create_list(:person, 3) }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('authors')
          expect(data).to have_key('pagination')
          expect(response).to have_http_status(:ok)
        end
      end
    end

    post 'Cria autor' do
      tags 'Autores'
      security [Bearer: {}]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :author_params, in: :body, schema: {
        type: :object,
        properties: {
          author: {
            type: :object,
            properties: {
              type: { type: :string, enum: ['Person', 'Institution'] },
              name: { type: :string },
              birth_date: { type: :string, format: 'date' },
              city: { type: :string }
            },
            required: ['type', 'name']
          }
        },
        required: ['author']
      }

      response '201', 'Autor criado' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author_params) do
          {
            author: {
              type: 'Person',
              name: 'Autor Teste',
              birth_date: '1980-01-01'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('data')
          expect(data['data']['attributes']['name']).to eq('Autor Teste')
          expect(response).to have_http_status(:created)
        end
      end

      response '422', 'Dados inválidos' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author_params) do
          {
            author: {
              type: 'Person',
              name: ''
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      response '401', 'Não autorizado' do
        # Não definir Authorization para testar cenário sem token
        let(:author_params) do
          {
            author: {
              type: 'Person',
              name: 'Autor Teste'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  path '/api/v1/authors/{id}' do
    get 'Mostra autor' do
      tags 'Autores'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Autor encontrado' do
        let(:author) { create(:person) }
        let(:id) { author.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('data')
          expect(data['data']['attributes']['name']).to eq(author.name)
          expect(response).to have_http_status(:ok)
        end
      end

      response '404', 'Autor não encontrado' do
        let(:id) { 'invalid' }

        run_test! do |response|
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    put 'Atualiza autor' do
      tags 'Autores'
      security [Bearer: {}]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :author_params, in: :body, schema: {
        type: :object,
        properties: {
          author: {
            type: :object,
            properties: {
              name: { type: :string },
              birth_date: { type: :string, format: 'date' },
              city: { type: :string }
            }
          }
        },
        required: ['author']
      }

      response '200', 'Autor atualizado' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author) { create(:person) }
        let(:id) { author.id }
        let(:author_params) do
          {
            author: {
              name: 'Nome Atualizado'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['attributes']['name']).to eq('Nome Atualizado')
          expect(response).to have_http_status(:ok)
        end
      end

      response '422', 'Dados inválidos' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author) { create(:person) }
        let(:id) { author.id }
        let(:author_params) do
          {
            author: {
              name: ''
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    delete 'Exclui autor' do
      tags 'Autores'
      security [Bearer: {}]
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'Autor excluído' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author) { create(:person) }
        let(:id) { author.id }

        run_test! do |response|
          expect(response).to have_http_status(:no_content)
        end
      end

      response '422', 'Não foi possível excluir' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }
        let(:author) { create(:person) }
        let(:id) { author.id }

        before do
          # Criar material vinculado ao autor para forçar o erro
          create(:material, author: author)
        end

        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
