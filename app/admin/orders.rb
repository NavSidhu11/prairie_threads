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

  filter :status
  filter :created_at

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: ["new", "paid", "shipped"]
    end
    f.actions
  end

end