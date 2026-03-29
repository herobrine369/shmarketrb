require "test_helper"

module Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin_user = users(:one)
      @normal_user = users(:two)
      @product = products(:one)
    end

    test "should redirect unauthenticated users" do
      get admin_products_url
      assert_redirected_to new_user_session_path
    end

    test "should reject non admin users" do
      sign_in @normal_user
      get admin_products_url

      assert_redirected_to root_path
    end

    test "should get index for admin user" do
      sign_in @admin_user
      get admin_products_url

      assert_response :success
      assert_select "h1", text: "Admin Product Management"
    end

    test "should filter by state" do
      sign_in @admin_user
      get admin_products_url, params: { state: "reserved" }

      assert_response :success
      assert_select "td", text: /reserved/i
    end

    test "should update product state" do
      sign_in @admin_user
      patch update_status_admin_product_url(@product), params: { state: "sold" }

      assert_redirected_to admin_products_url
      assert_equal "sold", @product.reload.state
    end

    test "should get show page for admin user" do
      sign_in @admin_user
      get admin_product_url(@product)

      assert_response :success
      assert_select "h1", text: "Product Detail (Admin)"
    end
  end
end
