# frozen_string_literal: true

class Post < ApplicationRecord
  paginates_per 50

  validates :title, presence: true
  validates :content, presence: true
end
