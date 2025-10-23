class Api::V1::AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:user][:email])
    
    if user&.valid_password?(params[:user][:password])
      # Gerar token JWT manualmente
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      
      render json: {
        status: { code: 200, message: "Logged in successfully." },
        data: {
          user: {
            id: user.id,
            email: user.email,
            created_at: user.created_at,
            updated_at: user.updated_at
          }
        },
        token: token
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Invalid email or password." }
      }, status: :unauthorized
    end
  end

  def logout
    # Para API stateless, o logout é feito no cliente apenas removendo o token
    render json: {
      status: { code: 200, message: "Logged out successfully." }
    }, status: :ok
  end
end
