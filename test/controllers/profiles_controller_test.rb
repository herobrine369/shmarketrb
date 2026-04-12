# test/controllers/profiles_controller_test.rb
require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)          # uses the fixture user (from test/fixtures/users.yml)
    sign_in @user                # Devise helper to sign in
  end

  test "should get show" do
    get profile_url
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url
    assert_response :success
  end

  test "should update profile with valid data" do
    patch profile_url, params: {
      user: {
        username: "newusername123",
        college: "New College"
      }
    }

    assert_redirected_to profile_url
    assert_equal "Profile updated successfully.", flash[:notice]

    @user.reload
    assert_equal "newusername123", @user.username
    assert_equal "New College", @user.college
  end

  test "should not update profile with invalid data" do
    patch profile_url, params: {
      user: { username: "" }   # username is required
    }

    assert_response :unprocessable_entity
    assert_template :edit
  end
end