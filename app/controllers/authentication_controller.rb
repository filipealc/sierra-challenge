# app/controllers/authentication_controller.rb

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  # POST /authenticate
  def create
    if valid_params?(params[:username], params[:password])
      token = issue_token(username: params[:username]) # This should be the actual user's ID
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private

  # Validates the username and password
  def valid_params?(username, password)
    username.present? && password.present? &&
    username == 'admin' && password == 'admin' # this definitely shouldn't be hardcoded
  end

  # Issues a JWT token for the authenticated user
  def issue_token(username:)
    payload = { username: username, exp: 1.minute.from_now.to_i }
    JWT.encode(payload, jwt_secret, 'HS256')
  end

  # Retrieves the JWT secret key
  def jwt_secret
    ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
  end
end
