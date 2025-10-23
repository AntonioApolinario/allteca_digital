require 'swagger_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  path '/api/v1/auth/login' do
    post 'Login de usuário' do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'usuario@example.com' },
          password: { type: :string, example: 'senha123' }
        },
        required: ['email', 'password']
      }

      response '200', 'Login realizado com sucesso' do
        run_test!
      end
    end
  end
end
