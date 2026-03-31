class ProfilesController < ApplicationController
  def show
    @user = current_user
    @profile = @user.products.order(created_at: :desc)
  end
end
