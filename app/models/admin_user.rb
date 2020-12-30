# frozen_string_literal: true

class AdminUser < ApplicationRecord
  include UserValidation

  def generate_token
    update_column(:token, BCrypt::Password.create(SecureRandom.base64(24)))
  end
end
