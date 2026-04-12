# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @total_listings        = @user.total_listings_count
    @active_listings_count = @user.active_listings_count
    @sold_count            = @user.sold_items_count
    @reserved_count        = @user.reserved_items_count

    # Toggle Listings (Recent vs All)
    if params[:listings] == "all"
      @listings = @user.products.order(created_at: :desc)
      @show_all_listings = true
    else
      @listings = @user.recent_listings(limit: 5)
      @show_all_listings = false
    end

    # Toggle Purchases (Recent vs All)
    if params[:purchases] == "all"
      @purchases = @user.purchases.includes(:product).order(created_at: :desc)
      @show_all_purchases = true
    else
      @purchases = @user.recent_purchases(limit: 5)
      @show_all_purchases = false
    end
  end
end
