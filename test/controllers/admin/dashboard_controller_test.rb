require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin_user = users(:one)
      @normal_user = users(:two)
    end

    test "should redirect unauthenticated users" do
      get admin_dashboard_url
      assert_redirected_to new_user_session_path
    end

    test "should reject non admin users" do
      sign_in @normal_user
      get admin_dashboard_url

      assert_redirected_to root_path
    end

    test "should get dashboard for admin user" do
      sign_in @admin_user
      get admin_dashboard_url

      assert_response :success
      assert_select "h1", text: "Admin Dashboard"
    end
  end
end
