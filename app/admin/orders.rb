ActiveAdmin.register Order do
  permit_params :status

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :subtotal
    column :tax_total
    column :grand_total
    column :created_at
    actions
  end

  show do
  attributes_table do
    row :id
    row :user
    row :status
    row :subtotal
    row :tax_total
    row :grand_total
    row :created_at
  end

  panel "Order Items" do
    table_for order.order_items do
      column :product
      column :quantity
      column :unit_price
    end
  end
end

  filter :status
  filter :created_at

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: [ "new", "paid", "shipped" ]
    end
    f.actions
  end
end
