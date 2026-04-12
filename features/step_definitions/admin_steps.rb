# features/step_definitions/admin_steps.rb
When("I change a product's state to {string}") do |new_state|
  @product ||= FactoryBot.create(:product, name: "Test Product for Admin")
  @new_state = new_state

  visit admin_products_path
  within("tr", text: @product.name) do
    click_button new_state.titleize
  end
end

Then("the status is updated immediately") do
  expect(page).to have_content(@new_state.titleize)
  expect(@product.reload.state).to eq(@new_state)
end