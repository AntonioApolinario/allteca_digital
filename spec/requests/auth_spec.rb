require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }
  let(:valid_credentials) do
    {
      auth: {
        email: user.email,
        password: 'password123'
      }
    }
  end
  let(:invalid_credentials) do
    {
      auth: {
        email: user.email,
        password: 'wrongpassword'
      }
    }
  end

  describe 'POST /api/v1/auth/login' do
    context 'with valid credentials' do
      before { post '/api/v1/auth/login', params: valid_credentials }

      it 'returns a JWT token' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('token')
        expect(json_response).to have_key('user')
      end
    end

    context 'with invalid credentials' do
      before { post '/api/v1/auth/login', params: invalid_credentials }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).to have_key('error')
      end
    end
  end

  describe 'GET /api/v1/auth/me' do
    context 'with valid token' do
      let(:token) { user.generate_jwt }

      before do
        get '/api/v1/auth/me', headers: { 'Authorization' => "Bearer #{token}" }
      end

      it 'returns user data' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('user')
        expect(json_response['user']['data']['attributes']['email']).to eq(user.email)
      end
    end

    context 'with invalid token' do
      before do
        get '/api/v1/auth/me', headers: { 'Authorization' => 'Bearer invalid_token' }
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/auth/logout' do
    context 'with valid token' do
      let(:token) { user.generate_jwt }

      before do
        delete '/api/v1/auth/logout', headers: { 'Authorization' => "Bearer #{token}" }
      end

      it 'returns success message' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('message')
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
