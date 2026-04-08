class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :conversations_as_user1, class_name: "Conversation", foreign_key: "user1_id"
  has_many :conversations_as_user2, class_name: "Conversation", foreign_key: "user2_id"

  def conversations
    Conversation.where("user1_id = ? OR user2_id = ?", id, id)
  end
end
