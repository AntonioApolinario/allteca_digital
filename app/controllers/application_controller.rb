class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pundit::Authorization
  
  respond_to :json
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    return @current_user if defined?(@current_user)
    
    auth_header = request.headers["Authorization"]
    return unless auth_header.present?
    
    token = auth_header.split(" ").last
    return unless token.present?
    
    begin
      # Usar a mesma chave que o Devise JWT
      secret = ENV.fetch("DEVISE_JWT_SECRET_KEY") { "test_secret_key_1234567890" }
      payload = JWT.decode(token, secret, true, { algorithm: 'HS256' })
      @current_user = User.find_by(id: payload[0]["sub"])
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT Decode Error: #{e.message}"
      @current_user = nil
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "User not found: #{e.message}"
      @current_user = nil
    rescue => e
      Rails.logger.error "Authentication error: #{e.message}"
      @current_user = nil
    end
  end

  def authenticate_user!
    render json: { error: "Não autorizado" }, status: :unauthorized unless current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def pundit_user
    current_user
  end

  private

  def user_not_authorized(exception)
    Rails.logger.warn "Pundit::NotAuthorizedError: #{exception.message}"
    render json: { error: "Você não está autorizado a realizar esta ação." }, status: :forbidden
  end

  def record_not_found(exception)
    Rails.logger.warn "ActiveRecord::RecordNotFound: #{exception.message}"
    render json: { error: "Registro não encontrado." }, status: :not_found
  end
end
