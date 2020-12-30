# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, only: :logout

  def login
    authenticate_user(User, params)
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
