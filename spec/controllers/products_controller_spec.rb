# spec/controllers/products_controller_spec.rb
require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let!(:product) { create(:product, user: user) }   # let! ensures it's created before tests

  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'supports search' do
      create(:product, name: 'Gaming Chair')
      get :index, params: { search: 'gaming' }
      expect(assigns(:products).map(&:name)).to include('Gaming Chair')
    end

    it 'supports category filter' do
      create(:product, category: 'furniture')
      get :index, params: { category: 'furniture' }
      expect(assigns(:products)).to all(have_attributes(category: 'furniture'))
    end
  end

  describe 'GET #show' do
    it 'shows the product' do
      get :show, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    it 'creates a new product assigned to current user' do
      expect {
        post :create, params: { product: attributes_for(:product) }
      }.to change(Product, :count).by(1)
      expect(Product.last.user).to eq(user)
      expect(response).to redirect_to(product_path(Product.last))
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    it 'destroys the product (owner only)' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(response).to redirect_to(products_path)
    end
  end
end