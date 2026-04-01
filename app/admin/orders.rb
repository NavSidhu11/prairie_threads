ActiveAdmin.register Order do
  config.filters = false
  permit_params :status
 form do |f|
    f.inputs do
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped']
    end
    f.actions
  end
end