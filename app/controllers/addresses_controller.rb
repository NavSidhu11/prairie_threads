class AddressesController < ApplicationController
  before_action :authenticate_user!

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)

    if @address.save
      redirect_to new_order_path, notice: "Address added!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address = current_user.addresses.find(params[:id])
  end

  def update
    @address = current_user.addresses.find(params[:id])

    if @address.update(address_params)
      redirect_to checkout_path, notice: "Address updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :postal_code, :province_id)
  end
end