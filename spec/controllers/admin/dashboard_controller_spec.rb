require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe 'GET #index' do
    # Create predictable test data before each example.
    # (Rails transactional fixtures will automatically roll back after each test.)
    before do
      # 3 available, 2 reserved, 1 sold → total = 6 products
      @user = User.create!(college: "abc", email: "abc@sfds.com", password: "abcdef", username: "abcdef", admin: true)
      3.times { Product.create!(state: 'available', category: "Desk Lamp", condition: "N/A", price: 34.00, user_id: @user.id, name: "abc") }
      2.times { Product.create!(state: 'reserved', category: "Desk Lamp", condition: "N/A", price: 34.00, user_id: @user.id, name: "abc") }
      1.times { Product.create!(state: 'sold', category: "Desk Lamp", condition: "N/A", price: 34.00, user_id: @user.id, name: "abc") }
    end

    before { sign_in @user }

    it 'assigns the correct product counts and the 5 most recent products' do
      get :index

      expect(assigns(:total_products)).to eq(6)
      expect(assigns(:available_products)).to eq(3)
      expect(assigns(:reserved_products)).to eq(2)
      expect(assigns(:sold_products)).to eq(1)

      # recent_products should be an ActiveRecord::Relation limited to 5 records
      expect(assigns(:recent_products)).to be_a(ActiveRecord::Relation)
      expect(assigns(:recent_products).count).to eq(5)
      expect(assigns(:recent_products)).to all(be_a(Product))
    end

    it 'renders the index template with a successful response' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end
end
