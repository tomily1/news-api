# frozen_string_literal: true

class AdminsController < ApplicationController
  private

  def authorize_admin
    return unauthorized('No authentication token provided') unless header =~ AUTH_FORMAT

    return unauthorized if TokenBlacklist.exists?(jwt_token: token)

    return unauthorized unless current_admin
  end

  def current_admin
    decoded = JsonWebToken.decode(token)
    @current_admin ||= AdminUser.find_by_id(decoded[:sub])
  end
end
