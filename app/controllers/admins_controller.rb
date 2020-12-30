# frozen_string_literal: true

class AdminsController < ApplicationController
  private

  def authorize_admin
    return unauthorized('No authentication token provided') unless header =~ AUTH_FORMAT

    return unauthorized if TokenBlacklist.exists?(jwt_token: token)

    return unauthorized unless current_admin
  end
end
