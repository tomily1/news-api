# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError, with: :jwt_error

  AUTH_FORMAT = %r{^Bearer [A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.?[A-Za-z0-9\-_.+/=]*$}.freeze

  def authorize_request
    return unauthorized('No authentication token provided') unless header =~ AUTH_FORMAT

    return unauthorized if TokenBlacklist.exists?(jwt_token: token)
    
    return unauthorized unless current_admin || current_user
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::ExpiredSignature => e
    render json: { errors: e.message }, status: :unauthorized
  end

  def ok(data = 'success', status = :ok)
    render json: { data: data }, status: status
  end

  def not_found
    render json: { error: 'not_found' }, status: :not_found
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

  def current_user
    decoded = JsonWebToken.decode(token)
    @current_user ||= User.find_by_id(decoded[:sub])
  end

  def current_admin
    decoded = JsonWebToken.decode(token)
    @current_admin ||= AdminUser.find_by_id(decoded[:sub])
  end

  def authenticate_user(klass, params)
    email = params[:email].try(:downcase)
    user = klass.where('LOWER(email) = ?', email).first

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(
        sub: user.id
      )

      render json: {
        access_token: token,
        token_type: 'Bearer',
        email: user.email
      }, status: :ok
    else
      unauthorized
    end
  end

  def register_user(klass, params)
    user = klass.new(params)
    if user.valid?
      user.save
      ok(user)
    else
      unprocessable_entity(user.errors)
    end
  end

  def jwt_error
    unprocessable_entity('Invalid or Expired Token')
  end
end
