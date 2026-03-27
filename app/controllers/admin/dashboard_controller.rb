module Admin
  class DashboardController < BaseController
    def index
      @total_products = Product.count
      @available_products = Product.where(state: "available").count
      @reserved_products = Product.where(state: "reserved").count
      @sold_products = Product.where(state: "sold").count
      @recent_products = Product.order(created_at: :desc).limit(5)
    end
  end
end
