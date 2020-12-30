# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "me#{n}@test.co" }
    password { 'Password1!' }
  end

  factory :admin_user do
    sequence(:email) { |n| "me#{n}@test.co" }
    password { 'Password1!' }

    trait :super_admin do
      super_admin { true }
    end
  end
end
