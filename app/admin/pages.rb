ActiveAdmin.register Page do
  config.filters = false
  permit_params :title, :content, :slug
end
