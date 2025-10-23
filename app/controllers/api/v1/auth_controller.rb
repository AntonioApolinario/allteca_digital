class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user!, only: [:logout, :me]
  skip_before_action :authenticate_user!, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      token = user.generate_jwt
      render json: { 
        token: token,
        user: UserSerializer.new(user).serializable_hash
      }, status: :ok
    else
      render json: { error: "Email ou senha inválidos" }, status: :unauthorized
    end
  end

  def logout
    render json: { message: "Logout realizado com sucesso" }, status: :ok
  end

  def me
    render json: UserSerializer.new(current_user).serializable_hash
  end
end
