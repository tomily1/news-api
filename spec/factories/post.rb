# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'mock title' }
    content { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua!' }
  end
end
