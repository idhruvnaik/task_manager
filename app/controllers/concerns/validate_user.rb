module ValidateUser
  include ActiveSupport::Concern

  def validate_user
    token = request.headers["Authorization"].split(" ")[1] rescue nil
    if token.nil?
      render_unauthorized and return
    end

    @user = User.find_by_auth_token token
    if @user.nil?
      render_unauthorized and return
    end
  end
end
