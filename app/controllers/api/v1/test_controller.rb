class Api::V1::TestController < ApiController
  skip_before_action :authenticate_user!
  
  def check_auth
    if current_user
      render json: { 
        authenticated: true, 
        user: current_user.email,
        user_id: current_user.id
      }
    else
      render json: { 
        authenticated: false,
        auth_header: request.headers["Authorization"],
        current_user: current_user.inspect
      }, status: :unauthorized
    end
  end
end
