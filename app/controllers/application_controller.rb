class ApplicationController < ActionController::API
  require \"kaminari\" # Garantir que Kaminari seja carregado
  
  include ActionController::MimeResponds
  include Pundit::Authorization
  
  respond_to :json
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    return unless request.headers[\"Authorization\"].present?
    
    token = request.headers[\"Authorization\"].split(\" \").last
    begin
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      @current_user ||= User.find(payload[\"sub\"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def authenticate_user!
    head :unauthorized unless current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def pundit_user
    current_user
  end

  private

  def user_not_authorized
    render json: { error: \"You are not authorized to perform this action.\" }, status: :forbidden
  end

  def record_not_found
    render json: { error: \"Record not found.\" }, status: :not_found
  end
end
