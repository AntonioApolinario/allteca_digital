class Api::V1::AuthController < ApiController
  before_action :authenticate_user!, only: [:logout, :me]

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: auth_params[:email])

    if user&.valid_password?(auth_params[:password])
      token = user.generate_jwt
      render json: {
        user: UserSerializer.new(user).serializable_hash,
        token: token
      }, status: :ok
    else
      render json: { error: "Email ou senha inválidos" }, status: :unauthorized
    end
  end

  # DELETE /api/v1/auth/logout
  def logout
    # Com JWT stateless, o logout é feito no cliente descartando o token
    # Em uma implementação real, poderíamos adicionar o token a uma blacklist
    render json: { message: "Logout realizado com sucesso" }, status: :ok
  end

  # GET /api/v1/auth/me
  def me
    render json: {
      user: UserSerializer.new(current_user).serializable_hash
    }, status: :ok
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
