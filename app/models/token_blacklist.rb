# frozen_string_literal: true

class TokenBlacklist < ApplicationRecord
  validates_uniqueness_of :jwt_token
end
