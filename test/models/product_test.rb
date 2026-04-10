require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "is invalid without required attributes" do
    product = Product.new

    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
    assert_includes product.errors[:category], "can't be blank"
    assert_includes product.errors[:condition], "can't be blank"
    assert_includes product.errors[:price], "can't be blank"
  end

  test "normalizes text and default status before validation" do
    product = Product.new(
      name: "  Admin Item  ",
      description: "  A demo description  ",
      category: "  Electronics  ",
      condition: "  Good  ",
      price: 10,
      post_date: Date.current,
      user: users(:one)
    )

    assert product.valid?
    assert_equal "Admin Item", product.name
    assert_equal "A demo description", product.description
    assert_equal "electronics", product.category
    assert_equal "good", product.condition
    assert_equal "available", product.state
  end

  test "rejects unknown states" do
    product = products(:one)
    product.state = "unknown"

    assert_not product.valid?
    assert_includes product.errors[:state], "is not included in the list"
  end
end
