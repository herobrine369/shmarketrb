class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @active_listings_count = @user.active_listings_count
    @sold_count = @user.sold_items_count
    @reserved_count = @user.reserved_items_count
    @total_listings = @user.total_listings_count
    @recent_listings = @user.recent_listings(limit: 5)
    @recent_purchases = @user.recent_purchases(limit: 5)
  end
end
