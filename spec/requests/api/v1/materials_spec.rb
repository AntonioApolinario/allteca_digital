require 'swagger_helper'

RSpec.describe 'Api::V1::Materials', type: :request do
  path '/api/v1/materials' do
    get 'Lista materiais' do
      tags 'Materiais'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :q, in: :query, type: :string, required: false

      response '200', 'Materiais listados' do
        run_test!
      end
    end
  end
end
