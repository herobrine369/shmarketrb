# features/step_definitions/authentication_steps.rb
Given("I am a registered user") do
  @user = FactoryBot.create(:user,
                            email: "testuser_#{Time.now.to_i}@example.com",
                            password: "password123",
                            username: "testuser",
                            college: "Shaw College"
  )
end

Given("I am signed in") do
  # @user ||= FactoryBot.create(:user, email: "testuser_#{Time.now.to_i}@example.com")
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
  expect(page).to have_content("Signed in successfully")
end

Given("I am signed in as admin") do
  @admin = FactoryBot.create(:admin, email: "admin_#{Time.now.to_i}@example.com")
  visit new_user_session_path
  fill_in "Email", with: @admin.email
  fill_in "Password", with: "password123"
  click_button "Log in"
  expect(page).to have_content("Signed in successfully")
end
