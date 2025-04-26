class ApplicationController < ActionController::API
  include RequestValidation
  include ValidateUser

  def render_unauthorized()
    render json: { message: "Unauthorized !!" }, status: :unauthorized
  end

  def render_success(data = {}, message = "Success !!", status = :ok)
    render json: { data: data, message: message }, status: status
  end

  def render_failure(data = {}, message = "Failure !!", status = :internal_server_error)
    render json: { data: data, message: message }, status: status
  end
end
