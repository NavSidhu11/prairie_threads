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
    @products = Product.where(id: @cart.keys)
    @addresses = current_user.addresses

    @subtotal = @products.sum do |p|
      p.price * @cart[p.id.to_s]
    end

    province = current_user.province || Province.first

    @gst = province.gst_rate
    @pst = province.pst_rate
    @hst = province.hst_rate

    @tax_total = @subtotal * (@gst + @pst + @hst) / 100.0
    @grand_total = @subtotal + @tax_total
  end

  def create
    cart = session[:cart] || {}
    products = Product.where(id: cart.keys)

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

    # 🔥 STRIPE PAYMENT
    token = params[:stripeToken]

    charge = Stripe::Charge.create(
      amount: (grand_total * 100).to_i,
      currency: "cad",
      description: "Prairie Threads Order",
      source: token
    )

    # 🔥 CREATE ORDER
    order = current_user.orders.create!(
      subtotal: subtotal,
      tax_total: tax_total,
      grand_total: grand_total,
      gst_rate: gst,
      pst_rate: pst,
      hst_rate: hst,
      status: "paid", # ✅ now paid after Stripe
      address: address,
      stripe_payment_id: charge.id # ✅ save Stripe ID
    )

    # 🔥 CREATE ORDER ITEMS
    products.each do |product|
      OrderItem.create!(
        order: order,
        product: product,
        quantity: cart[product.id.to_s],
        unit_price: product.price
      )
    end

    # 🔥 CLEAR CART
    session[:cart] = {}

    redirect_to order_path(order), notice: "Payment successful! Order placed."
  end
end
