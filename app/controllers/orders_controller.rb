class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @cart = session[:cart] || {}
    @products = Product.find(@cart.keys)
    @addresses = current_user.addresses

    @subtotal = @products.sum do |p|
      p.price * @cart[p.id.to_s]
    end

    province = current_user.province || Province.first

    gst = province.gst_rate
    pst = province.pst_rate
    hst = province.hst_rate

    @tax_total = @subtotal * (gst + pst + hst) / 100.0
    @grand_total = @subtotal + @tax_total

    @gst = gst
    @pst = pst
    @hst = hst
  end

  def create
    cart = session[:cart] || {}
    products = Product.find(cart.keys)

    subtotal = products.sum do |p|
      p.price * cart[p.id.to_s]
    end

    address = current_user.addresses.find(params[:address_id])
    province = address.province

    gst = province.gst_rate
    pst = province.pst_rate
    hst = province.hst_rate

    tax_total = subtotal * (gst + pst + hst) / 100.0
    grand_total = subtotal + tax_total

    order = current_user.orders.create!(
      subtotal: subtotal,
      tax_total: tax_total,
      grand_total: grand_total,
      gst_rate: gst,
      pst_rate: pst,
      hst_rate: hst,
      status: "new",
      address: address
    )

    products.each do |product|
      OrderItem.create!(
        order: order,
        product: product,
        quantity: cart[product.id.to_s],
        unit_price: product.price
      )
    end

    session[:cart] = {}

    redirect_to order_path(order), notice: "Order placed successfully!"
  end
end