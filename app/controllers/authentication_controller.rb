# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, only: :logout

  def login
    email = params[:email].try(:downcase)
    user = User.where('LOWER(email) = ?', email).first

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

  def logout
    invalidate_token
    render json: { message: 'logged out' }, status: :ok
  end

  private

  def invalidate_token
    blacklist = TokenBlacklist.new(jwt_token: token, expiration_date: 1.hour.from_now)
    blacklist.save
  end
end
