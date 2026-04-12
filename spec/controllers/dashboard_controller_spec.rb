# spec/controllers/dashboard_controller_spec.rb
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #show' do
    it 'requires authentication' do
      sign_out user
      get :show
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'assigns correct stats' do
      create_list(:product, 4, user: user, state: 'available')
      create_list(:product, 2, user: user, state: 'sold')
      create_list(:product, 1, user: user, state: 'reserved')
      create_list(:transaction, 3, buyer: user)

      get :show

      expect(assigns(:total_listings)).to eq(7)
      expect(assigns(:active_listings_count)).to eq(4)
      expect(assigns(:sold_count)).to eq(2)
      expect(assigns(:reserved_count)).to eq(1)
    end

    it 'shows recent listings by default' do
      get :show
      expect(assigns(:show_all_listings)).to be_falsey
    end

    it 'shows all listings when requested' do
      get :show, params: { listings: 'all' }
      expect(assigns(:show_all_listings)).to be_truthy
    end
  end
end
