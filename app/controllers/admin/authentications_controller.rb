# frozen_string_literal: true

module Admin
  class AuthenticationsController < AdminsController
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
  end
end
