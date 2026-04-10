class Product < ApplicationRecord
  STATES = %w[draft available reserved sold].freeze # restrict states to draft/available/reserved/sold

  before_validation :normalize_text_attributes
  before_validation :set_default_state
  before_validation :set_default_post_date

  validates :name, :category, :condition, :post_date, presence: true
  validates :description, length: { maximum: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :state, presence: true, inclusion: { in: STATES } # check if status is draft/available/reserved/sold

  belongs_to :user

  has_many :transactions

  # for active storage
  has_one_attached :image

  scope :search, ->(query) {
    next all if query.blank?

    sanitized_query = "%#{sanitize_sql_like(query.downcase)}%"
    where(
      "LOWER(name) LIKE :query OR LOWER(description) LIKE :query OR LOWER(category) LIKE :query",
      query: sanitized_query
    )
  }
  scope :with_state, ->(state) { state.present? ? where(state:) : all }
  scope :with_category, ->(category) { category.present? ? where(category:) : all }
  scope :with_min_price, ->(min_price) { min_price.present? ? where("price >= ?", min_price) : all }
  scope :with_max_price, ->(max_price) { max_price.present? ? where("price <= ?", max_price) : all }

  private

  def normalize_text_attributes
    self.name = name.to_s.strip
    self.category = category.to_s.strip.downcase
    self.condition = condition.to_s.strip.downcase
    self.description = description.to_s.strip
    self.state = state.to_s.strip.downcase
  end

  def set_default_state
    self.state = "available" if new_record? && state.blank?
  end

  def set_default_post_date
    self.post_date = Date.today # let post date be today by default
  end
end
