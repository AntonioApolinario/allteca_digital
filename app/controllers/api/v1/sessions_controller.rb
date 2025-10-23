class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    
    render json: {
      status: { code: 200, message: "Logged in successfully." },
      data: {
        user: {
          id: resource.id,
          email: resource.email,
          created_at: resource.created_at,
          updated_at: resource.updated_at
        }
      }
    }, status: :ok
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    
    if signed_out
      render json: {
        status: { code: 200, message: "Logged out successfully." }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Could not find an active session." }
      }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
