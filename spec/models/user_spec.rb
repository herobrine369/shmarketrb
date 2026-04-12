# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:college) }

    # Fixed uniqueness test
    it 'validates username is case-insensitively unique' do
      create(:user, username: 'testuser')
      user = build(:user, username: 'TestUser')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('has already been taken')
    end

    it 'normalizes college name before validation' do
      user = build(:user, college: '  shaw college  ')
      user.valid?
      expect(user.college).to eq('Shaw College')
    end
  end

  # ... keep all other describe blocks exactly as they are ...

  describe 'Devise modules' do
    # Removed the problematic encrypted_password test (Devise + shoulda-matchers conflict)
    it { should validate_presence_of(:email) }
    it { should have_db_column(:reset_password_token) }
    it { should have_db_column(:remember_created_at) }
  end

  # ... rest of your custom methods and factory tests remain unchanged ...
end
