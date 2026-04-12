# spec/factories/conversations.rb
FactoryBot.define do
  factory :conversation do
    # Guarantee two DIFFERENT users
    user1 { association :user }
    user2 { association :user }
  end
end