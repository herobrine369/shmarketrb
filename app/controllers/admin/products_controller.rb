module Admin
  class ProductsController < BaseController
    PER_PAGE = 10
    SORT_OPTIONS = {
      "newest" => { created_at: :desc },
      "oldest" => { created_at: :asc },
      "price_low" => { price: :asc },
      "price_high" => { price: :desc },
      "state" => { state: :asc, created_at: :desc }
    }.freeze

    before_action :set_product, only: [ :show, :update_status ]

    def index
      @query = params[:query].to_s.strip
      @state = params[:state].to_s
      @category = params[:category].to_s
      @min_price = params[:min_price].to_s
      @max_price = params[:max_price].to_s
      @sort = params[:sort].presence_in(SORT_OPTIONS.keys) || "newest"
      @page = [ params[:page].to_i, 1 ].max

      filtered_products = Product
        .search(@query)
        .with_state(@state)
        .with_category(@category)
        .with_min_price(@min_price)
        .with_max_price(@max_price)
        .order(SORT_OPTIONS.fetch(@sort))

      @total_count = filtered_products.count
      @total_pages = [ (@total_count.to_f / PER_PAGE).ceil, 1 ].max
      @page = @total_pages if @page > @total_pages
      @products = filtered_products.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)

      @state_options = Product::STATES
      @category_options = Product.where.not(category: [ nil, "" ]).distinct.order(:category).pluck(:category)
    end

    def show
    end

    def update_status
      new_state = params.expect(:state).to_s.downcase

      if Product::STATES.include?(new_state) && @product.update(state: new_state)
        redirect_to admin_products_path(request.query_parameters), notice: "Product status updated to #{new_state}."
      else
        redirect_to admin_products_path(request.query_parameters), alert: "Failed to update product status."
      end
    rescue ActionController::ParameterMissing
      redirect_to admin_products_path(request.query_parameters), alert: "Missing status parameter."
    end

    private

    def set_product
      @product = Product.find(params.expect(:id))
    end
  end
end
