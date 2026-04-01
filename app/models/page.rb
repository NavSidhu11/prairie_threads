class Page < ApplicationRecord
  validates :slug, :title, :body, presence: true
end