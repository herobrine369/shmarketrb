require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:condition) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_inclusion_of(:state).in_array(Product::STATES) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:transactions) }
    it { should have_one_attached(:image) }
  end

  describe "callbacks" do
    it "normalizes text attributes" do
      product = build(:product, name: "  Cool Desk  ", category: "FURNITURE")
      product.valid?
      expect(product.name).to eq("Cool Desk")
      expect(product.category).to eq("furniture")
    end

    it "sets default state to available" do
      product = create(:product, state: nil)
      expect(product.state).to eq("available")
    end
  end

  describe "scopes" do
    it ".search returns matching products" do
      create(:product, name: "iPhone")
      expect(Product.search("iphone").count).to eq(1)
    end

    it ".with_state filters correctly" do
      create(:product, state: "reserved")
      expect(Product.with_state("reserved").count).to eq(1)
    end
  end
end