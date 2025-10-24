require 'swagger_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  path '/api/v1/auth/login' do
    post 'Login de usuário' do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :auth_params, in: :body, schema: {
        type: :object,
        properties: {
          auth: {
            type: :object,
            properties: {
              email: { type: :string, example: 'usuario@example.com' },
              password: { type: :string, example: 'senha123' }
            },
            required: ['email', 'password']
          }
        },
        required: ['auth']
      }

      let(:user) { create(:user) }

      response '200', 'Login realizado com sucesso' do
        let(:auth_params) do
          {
            auth: {
              email: user.email,
              password: 'password123'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('user')
          expect(data).to have_key('token')
          expect(response).to have_http_status(:ok)
        end
      end

      response '401', 'Credenciais inválidas' do
        let(:auth_params) do
          {
            auth: {
              email: user.email,
              password: 'wrong_password'
            }
          }
        end

        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  path '/api/v1/auth/me' do
    get 'Retorna dados do usuário autenticado' do
      tags 'Autenticação'
      produces 'application/json'
      security [Bearer: {}]

      let(:user) { create(:user) }

      response '200', 'Dados do usuário retornados' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('user')
          expect(data['user']['data']['attributes']['email']).to eq(user.email)
          expect(response).to have_http_status(:ok)
        end
      end

      response '401', 'Não autorizado' do
        let(:Authorization) { 'Bearer invalid_token' }

        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  path '/api/v1/auth/logout' do
    delete 'Logout' do
      tags 'Autenticação'
      produces 'application/json'
      security [Bearer: {}]

      let(:user) { create(:user) }

      response '200', 'Logout realizado com sucesso' do
        let(:Authorization) { "Bearer #{user.generate_jwt}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('message')
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
