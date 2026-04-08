class Province < ApplicationRecord
  has_many :users
  has_many :addresses

  validates :name, :abbreviation, presence: true
  validates :gst_rate, :pst_rate, :hst_rate, presence: true, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "abbreviation", "gst_rate", "pst_rate", "hst_rate", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["addresses", "users"]
  end
end