ActiveAdmin.register Product do
  config.filters = false

  permit_params :name, :description, :price, :stock_quantity, :on_sale, :sale_price, :image, category_ids: []

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :on_sale
      f.input :sale_price
      f.input :categories, as: :check_boxes
      f.input :image, as: :file
    end
    f.actions
  end
end