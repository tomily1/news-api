# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError, with: :jwt_error

  AUTH_FORMAT = %r{^Bearer [A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.?[A-Za-z0-9\-_.+/=]*$}.freeze

  def authorize_request
    return unauthorized('No authentication token provided') unless header =~ AUTH_FORMAT

    return unauthorized if TokenBlacklist.exists_for?(token)

    decoded = JsonWebToken.decode(token)
    User.find_by_id(decoded[:sub])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::ExpiredSignature => e
    render json: { errors: e.message }, status: :unauthorized
  end

  def ok(data = 'success')
    render json: { data: data }, status: :ok
  end

  def unprocessable_entity(message = 'unprocessable_entity')
    render json: { error: message }, status: :unprocessable_entity
  end

  def unauthorized(message = 'unauthorized', data = {})
    response = { error: message }.merge(data)
    render json: response, status: :unauthorized
  end

  def header
    request.headers['Authorization']
  end

  def token
    header&.split(' ')&.last
  end

  private

  def jwt_error
    unprocessable_entity('Invalid or Expired Token')
  end
end
