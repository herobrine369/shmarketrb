# spec/controllers/chats_controller_spec.rb
require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe 'GET #show' do
    it 'creates or finds conversation and renders chat' do
      get :show, params: { user_id: other_user.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:conversation)).to be_a(Conversation)
      expect(assigns(:other_user)).to eq(other_user)
    end

    it 'prevents chatting with yourself' do
      get :show, params: { user_id: user.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include('cannot chat with yourself')
    end

    it 'redirects if user does not exist' do
      get :show, params: { user_id: 999999 }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include('User not found')
    end
  end
end
