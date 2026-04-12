# spec/models/conversation_spec.rb
require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user1_id) }
    it { should validate_presence_of(:user2_id) }

    it 'validates that users are different' do
      user = create(:user)
      conversation = build(:conversation, user1_id: user.id, user2_id: user.id)
      expect(conversation).not_to be_valid
      expect(conversation.errors[:base]).to include('Cannot chat with yourself')
    end
  end

  describe 'associations' do
    it { should belong_to(:user1).class_name('User') }
    it { should belong_to(:user2).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe '.find_or_create_between' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }

    it 'creates a conversation when none exists' do
      expect {
        Conversation.find_or_create_between(user_a, user_b)
      }.to change(Conversation, :count).by(1)
    end

    it 'returns existing conversation if it already exists' do
      existing = Conversation.find_or_create_between(user_a, user_b)
      expect(Conversation.find_or_create_between(user_a, user_b)).to eq(existing)
    end

    it 'always puts the smaller ID in user1_id' do
      conversation = Conversation.find_or_create_between(user_b, user_a)
      expect(conversation.user1_id).to eq([ user_a.id, user_b.id ].min)
      expect(conversation.user2_id).to eq([ user_a.id, user_b.id ].max)
    end

    it 'returns nil if same user or nil' do
      expect(Conversation.find_or_create_between(user_a, user_a)).to be_nil
      expect(Conversation.find_or_create_between(user_a, nil)).to be_nil
    end
  end

  describe 'factory' do
    it 'creates a valid conversation' do
      conversation = create(:conversation)   # ←←← CHANGED FROM build TO create
      expect(conversation).to be_valid
      expect(conversation.user1).to be_present
      expect(conversation.user2).to be_present
      expect(conversation.user1_id).not_to eq(conversation.user2_id)
    end
  end
end
