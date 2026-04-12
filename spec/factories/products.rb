# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    name { "Test Product" }
    description { "A nice test item" }
    category { "furniture" }
    condition { "brand new" }
    price { 99.99 }
    post_date { Date.today }
    state { "available" }
    association :user
  end
end
