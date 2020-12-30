# frozen_string_literal: true

class Post < ApplicationRecord
  paginates_per 50
end
