# spec/controllers/profiles_controller_spec.rb
require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user, username: "oldname", college: "Old College") }

  before { sign_in user }

  describe 'authentication' do
    it 'requires user to be signed in' do
      sign_out user
      get :show
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET #show' do
    it 'assigns the current user and renders show' do
      get :show
      expect(assigns(:user)).to eq(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'assigns the current user and renders edit' do
      get :edit
      expect(assigns(:user)).to eq(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates username and college' do
        patch :update, params: {
          user: {
            username: "newusername",
            college: "New College"
          }
        }

        user.reload
        expect(user.username).to eq("newusername")
        expect(user.college).to eq("New College")
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to eq("Profile updated successfully.")
      end
    end

    context 'with invalid parameters' do
      it 'does not update and re-renders the edit form' do
        patch :update, params: { user: { username: '' } }

        expect(user.reload.username).to eq("oldname") # unchanged
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'strong parameters' do
    it 'only permits username, college and avatar (ignores others)' do
      patch :update, params: {
        user: {
          username: "testuser",
          college: "Test College",
          email: "hacked@example.com",   # should be ignored
          admin: true                    # should be ignored
        }
      }

      user.reload
      expect(user.email).not_to eq("hacked@example.com")
      expect(user.admin).to be_falsey
    end
  end
end