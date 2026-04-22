class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)

    @q = Product.includes(:categories).ransack(params[:q])
    @products = @q.result(distinct: true)

    # Filters
    case params[:filter]
    when "on_sale"
      @products = @products.on_sale_only
    when "new"
      @products = @products.new_only
    when "recently_updated"
      @products = @products.recently_updated_only
    end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
