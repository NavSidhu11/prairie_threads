class CartController < ApplicationController
  def show
  session[:cart] ||= {}

  valid_ids = Product.pluck(:id).map(&:to_s)
  session[:cart].slice!(*valid_ids)

  @cart = session[:cart]
  @products = Product.find(@cart.keys)
end

  def add
    session[:cart] ||= {}

    product_id = params[:product_id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path, notice: "Added to cart"
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    session[:cart][product_id] = quantity

    redirect_to cart_path, notice: "Cart updated"
  end

  def remove
    product_id = params[:product_id].to_s
    session[:cart].delete(product_id)

    redirect_to cart_path, notice: "Item removed"
  end
end
