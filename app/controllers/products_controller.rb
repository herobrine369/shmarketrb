class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show ] # only log in user can create, edit and destroy
  before_action :correct_user, only: %i[ edit update destroy ] # only owner of this product can edit and destroy


  # GET /products or /products.json
  def index
    @products = Product.all

    # for search function
    if params[:search].present?
      @products = @products.search(params[:search])
    end

    # for filter
    if params[:category].present?
      @products = @products.where(category: params[:category])
    end

    respond_to do |format|
    format.html
    format.json { render json: @products }
  end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user # to assign user

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, notice: "Product was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :image, :name, :description, :category, :state, :condition, :price, :post_date ])
    end
    # check if it's owner
    def correct_user
      unless @product.user == current_user
        redirect_to @product, alert: "You are not authorized to do that."
      end
    end
end
