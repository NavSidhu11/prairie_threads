class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :orders

  validates :street, :city, :postal_code, presence: true

  def self.ransackable_attributes(auth_object = nil)
  [
    "id",
    "street",
    "city",
    "postal_code",
    "province_id",
    "user_id",
    "created_at",
    "updated_at"
  ]
end

def self.ransackable_associations(auth_object = nil)
  [ "user", "province" ]
end
end
