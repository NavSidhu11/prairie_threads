class Province < ApplicationRecord
  has_many :users
  has_many :addresses

  validates :name, :abbreviation, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, presence: true, numericality: true
end