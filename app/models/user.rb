class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :sales, class_name: "Transaction", foreign_key: "seller_id"
  has_many :purchases, class_name: "Transaction", foreign_key: "buyer_id"

  has_one_attached :avatar

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :college, presence: true
  validates :admin, inclusion: { in: [ true, false ] }

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
  end
end
