class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :user1_id, :user2_id, presence: true
  validate :users_are_different

  # app/models/conversation.rb
  def self.find_or_create_between(user1, user2)
    return nil if user1 == user2 || user1.nil? || user2.nil?

    # Always put the smaller ID in user1_id to avoid duplicate conversations
    if user1.id < user2.id
      find_or_create_by(user1_id: user1.id, user2_id: user2.id)
    else
      find_or_create_by(user1_id: user2.id, user2_id: user1.id)
    end
  end


  private

  def users_are_different
    errors.add(:base, "Cannot chat with yourself") if user1_id == user2_id
  end
end
