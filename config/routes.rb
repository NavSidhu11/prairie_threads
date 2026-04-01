Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)

  root "home#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]
  resources :pages, only: [:show], param: :slug

 resource :cart, controller: "cart", only: [:show] do
  post :add
  patch :update
  delete :remove
end

  resources :orders, only: [:index, :show, :new, :create]
  resources :addresses, only: [:new, :create, :edit, :update]
end