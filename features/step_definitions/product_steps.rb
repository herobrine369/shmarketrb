# features/step_definitions/product_steps.rb
When("I visit the new product page") do
  visit new_product_path
end

When("I fill in valid product details") do
  fill_in "Name", with: "Gaming Chair"
  fill_in "Description", with: "Barely used DXRacer chair"
  select "Furniture", from: "Category"
  select "Brand new", from: "Condition"
  fill_in "Price", with: "450"
end

When("I submit the form") do
  click_button "Create Product"
end

Then("I should see the product on the marketplace") do
  expect(page).to have_content("Gaming Chair")
  expect(page).to have_content("450")
end

Given("there are multiple products") do
  FactoryBot.create(:product,
                    name: "Desk Lamp",
                    category: "electronics",
                    user: FactoryBot.create(:user, email: "lamp_#{Time.now.to_i}@example.com")
  )

  FactoryBot.create(:product,
                    name: "Office Chair",
                    category: "furniture",
                    user: FactoryBot.create(:user, email: "chair_#{Time.now.to_i}@example.com")
  )

  FactoryBot.create(:product,
                    name: "iPhone 14",
                    category: "electronics",
                    user: FactoryBot.create(:user, email: "iphone_#{Time.now.to_i}@example.com")
  )
end

When("I search for {string}") do |term|
  fill_in "search", with: term          # ←←← Fixed: use name="search"
  click_button "Search"
end

When("I filter by category {string}") do |category|
  click_link category
end

Then("I should only see matching products") do
  expect(page).to have_content("Desk Lamp")
  expect(page).not_to have_content("iPhone 14")
  expect(page).not_to have_content("Office Chair")
end

Given("a product exists") do
  @seller = FactoryBot.create(:user,
                             email: "seller_#{Time.now.to_i}@example.com",
                             username: "seller123")
  @product = FactoryBot.create(:product,
                               name: "Mechanical Keyboard",
                               user: @seller
  )
end

When("I visit the product page") do
  visit product_path(@product)
end

When("I click {string}") do |text|
  click_link_or_button text
end

Then("I should be redirected to the chat with the seller") do
  expect(page).to have_current_path(chat_path(@product.user))
  expect(page).to have_content(@seller.email)
end

When(/^I visit the product list page$/) do
  visit products_url
end
