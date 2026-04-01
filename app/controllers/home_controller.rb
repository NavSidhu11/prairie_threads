class HomeController < ApplicationController
  def index
    @products = Product.order(created_at: :desc).limit(8)
    @categories = Category.order(:name)
  end
end