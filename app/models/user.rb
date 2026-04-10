class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
<<<<<<< HEAD
  has_many :sales, class_name: "Transaction", foreign_key: "seller_id"
  has_many :purchases, class_name: "Transaction", foreign_key: "buyer_id"

  has_one_attached :avatar

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :college, presence: true
  validates :is_admin, inclusion: { in: [ true, false ] }

  def total_listings_count
    products.count
  end

  def active_listings
    products.where(state: "available")
  end

  def active_listings_count
    active_listings.count
  end

  def sold_items_count
    products.where(state: "sold").count
  end

  def reserved_items_count
    products.where(state: "reserved").count
  end

  def recent_listings(limit: 5)
    products.order(post_date: :desc).limit(limit)
  end

  def recent_purchases(limit: 5)
    purchases.includes(:product).order(created_at: :desc).limit(limit)
  end

  before_validation :normalize_college_name

  private
  def normalize_college_name
    self.college = college.to_s.strip.titleize if college.present?
=======
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :conversations_as_user1, class_name: "Conversation", foreign_key: "user1_id"
  has_many :conversations_as_user2, class_name: "Conversation", foreign_key: "user2_id"

  def conversations
    Conversation.where("user1_id = ? OR user2_id = ?", id, id)
>>>>>>> main
  end
end
