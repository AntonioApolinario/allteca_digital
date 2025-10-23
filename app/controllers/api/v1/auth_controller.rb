class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      token = user.generate_jwt
      render json: { 
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    # Com JWT stateless, o logout é feito no cliente
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
