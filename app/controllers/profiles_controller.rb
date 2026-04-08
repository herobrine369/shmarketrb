class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
    @my_listings = current_user.products.includes(:transactions).order(post_date: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :college)
  end
end
