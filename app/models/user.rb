class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
  [
    "id",
    "email",
    "first_name",
    "last_name",
    "phone",
    "province_id",
    "created_at",
    "updated_at"
  ]
end

def self.ransackable_associations(auth_object = nil)
  [ "province", "addresses", "orders" ]
end
end
