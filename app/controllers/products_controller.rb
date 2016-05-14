class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:show,:index] 

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show

  end

  # GET /products/new
  def new
    @product = Product.new
    
    #Category.find(params[:parent_id]).products<<@product
    #@category =CategoryProduct.new(product_params)
    #@category = Category.all#.map{|c| [ c.parent_id,c.name, c.id] }
    #Category.find(params[:parent_id]).products<<@product
    #Category_product.create
    #@category =Category.alll
  end

  # GET /products/1/edit
  def edit

  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    #创建products的category
    #tmp=params[:parent_id]
    @product.category_ids = @product.parent_id

    #Category.find(params[:parent_id]).products<<@product
    #@product.categories << Category.new
    respond_to do |format|
      if @product.save
        #Category.find(params[:parent_id]).products<<@product
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        @product.category_ids = @product.parent_id
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      #@product.parent_id
      #@category = Category.find(params[:category_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name_cn, :name_jp, :price, :introduction, :pic_url, :parent_id, {avatars: []})
    end
end
