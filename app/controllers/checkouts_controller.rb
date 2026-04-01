class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = session[:cart]
    @products = Product.where(id: @cart_items.keys)

    if @products.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @address = current_user.addresses.last
  end

 def create
  @cart_items = session[:cart]
  @products = Product.where(id: @cart_items.keys)
  @address = current_user.addresses.last

  if @products.empty?
    redirect_to cart_path, alert: "Your cart is empty."
    return
  end

  if @address.blank?
    redirect_to new_address_path, alert: "Please add an address before checkout."
    return
  end

  province = @address.province
  subtotal = 0

  @products.each do |product|
    quantity = @cart_items[product.id.to_s]
    subtotal += product.current_price * quantity
  end

  gst = subtotal * (province.gst_rate / 100)
  pst = subtotal * (province.pst_rate / 100)
  hst = subtotal * (province.hst_rate / 100)
  tax_total = gst + pst + hst
  grand_total = subtotal + tax_total

  order = current_user.orders.create!(
    address: @address,
    status: "new",
    gst_rate: province.gst_rate,
    pst_rate: province.pst_rate,
    hst_rate: province.hst_rate,
    subtotal: subtotal,
    tax_total: tax_total,
    grand_total: grand_total
  )

  @products.each do |product|
    quantity = @cart_items[product.id.to_s]

    order.order_items.create!(
      product: product,
      quantity: quantity,
      unit_price: product.current_price
    )
  end

  session[:cart] = {}

  redirect_to order_path(order), notice: "Order placed successfully."
end
end