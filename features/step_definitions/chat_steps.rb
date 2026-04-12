# features/step_definitions/chat_steps.rb
Given("two users have a conversation") do
  @buyer  = FactoryBot.create(:user,
                              email: "buyer_#{Time.now.to_i}@example.com",
                              username: "buyer")
  @seller = FactoryBot.create(:user,
                              email: "seller_#{Time.now.to_i}@example.com",
                              username: "seller123")

  @conversation = Conversation.find_or_create_between(@buyer, @seller)

  visit new_user_session_path
  fill_in "Email", with: @buyer.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

When("user A sends a message") do
  visit chat_path(@seller.id)
  fill_in "message_content", with: "Hey, is the keyboard still available?"
  click_button "Send"
end

Then("user B sees the message instantly via Action Cable") do
  using_wait_time 10 do
    # Reliable logout using Devise route (no link clicking)
    page.driver.submit :delete, destroy_user_session_path, {}

    # Sign in as seller
    visit new_user_session_path
    fill_in "Email", with: @seller.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    visit chat_path(@buyer.id)
    expect(page).to have_content("Hey, is the keyboard still available?")
  end
end