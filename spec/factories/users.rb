# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:username) { |n| "user#{n}" }
    college { "Shaw College" }
    admin { false }

    trait :admin do
      admin { true }
      username { "admin" }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
end