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

  def render_failure(data = {}, message = "Failure !!", status = :internal_server_error)
    render json: { data: data, message: message }, status: status
  end

  def check_rate_limit
    key = "user:api_limit:#{@user.id}:#{params["controller"]}:#{params["action"]}"
    allowed = RateLimit.limit(key: key, limit: 1, period: 60 * 2)

    unless allowed
      render_failure({}, "Limit exceeded !!", :too_many_requests) and return
    end
  end
end
