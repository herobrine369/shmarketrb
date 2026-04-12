# spec/factories/transactions.rb
FactoryBot.define do
  factory :transaction do
    association :seller, factory: :user
    association :buyer, factory: :user
    association :product
    is_successful { true }
  end
end