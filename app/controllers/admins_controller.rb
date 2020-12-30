# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authorize_admin, except: %i[login]
  before_action :authorize_super_admin, only: :create

  def login
    authenticate_user(AdminUser, params)
  end

  def create
    register_user(AdminUser, admin_params)
  end

  private

  def admin_params
    params.permit(
      :email,
      :password,
      :password_confirmation
    )
  end

  def authorize_super_admin
    return unauthorized unless current_admin&.super_admin?
  end

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
