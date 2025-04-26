class UserController < ApplicationController
  def sign_up
    unless validate_params(["name", "email", "password"])
      return
    end

    begin
      ActiveRecord::Base.transaction do
        user = User.create!(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password])
      end

      render_success(user, "Profile created", :created) and return
    rescue => error
      render_failure({}, error.message, :internal_server_error) and return
    end
  end

  def log_in
    unless validate_params(["email", "password"])
      return
    end

    user = User.find_by_email params[:email]
    if user.present? && user.authenticate(params[:password])
      if user.respond_to?(:regenerate_auth_token)
        user.regenerate_auth_token
        render_success(user, "Authenticated!") and return
      end
    end

    render_unauthorized and return
  end
end
