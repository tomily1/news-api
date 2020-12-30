# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    register_user(User, user_params)
  end

  private

  def user_params
    params.permit(
      :email,
      :password,
      :password_confirmation
    )
  end
end
