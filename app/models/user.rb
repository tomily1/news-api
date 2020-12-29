# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, email_format: true, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, length: { minimum: 6 }
end
