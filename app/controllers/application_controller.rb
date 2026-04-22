class ApplicationController < ActionController::Base
before_action :initialize_cart
before_action :configure_permitted_parameters, if: :devise_controller?

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [
    :first_name,
    :last_name,
    :province_id
  ])

  devise_parameter_sanitizer.permit(:account_update, keys: [
    :first_name,
    :last_name,
    :province_id
  ])
end

def initialize_cart
  session[:cart] ||= {}
end

def set_categories
  @categories = Category.order(:name)
end
end
