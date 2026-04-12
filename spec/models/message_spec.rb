# spec/models/message_spec.rb
require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:sender).class_name('User') }
  end

  describe 'factory' do
    it 'creates a valid message' do
      expect(build(:message)).to be_valid
    end
  end

  describe 'broadcasting' do
    it 'can be created with a sender and conversation' do
      conversation = create(:conversation)
      sender = create(:user)
      message = create(:message, conversation: conversation, sender: sender)

      expect(message.conversation).to eq(conversation)
      expect(message.sender).to eq(sender)
    end
  end
end
