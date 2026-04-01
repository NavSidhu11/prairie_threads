ActiveAdmin.register Province do
  config.filters = false
  permit_params :name, :abbreviation, :gst_rate, :pst_rate, :hst_rate
end