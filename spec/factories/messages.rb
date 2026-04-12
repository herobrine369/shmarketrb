# spec/factories/messages.rb
FactoryBot.define do
  factory :message do
    content { "This is a test message." }
    association :conversation
    association :sender, factory: :user
  end
end