# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      # The JWT gem will automatically verify the expiration date and return a JWT::ExpiredSignature error if the token is expired
      JWT.decode(header, ENV['SECRET_KEY_BASE'], true, { algorithm: 'HS256' })
    rescue JWT::ExpiredSignature
      render json: { errors: 'Token has expired' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
