# frozen_string_literal: true

class AuthenticationController < ApplicationController
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
    render json: { message: 'logged out' }, status: :ok
  rescue JWT::DecodeError
    unauthorized
  end
end
