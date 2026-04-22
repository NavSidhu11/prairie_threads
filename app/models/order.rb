class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  STATUSES = %w[new paid shipped].freeze

  after_initialize do
  self.status ||= "new"
end

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :subtotal, :tax_total, :grand_total, numericality: true
  validates :gst_rate, :pst_rate, :hst_rate, numericality: true
def self.ransackable_attributes(auth_object = nil)
  [ "id", "status", "subtotal", "tax_total", "grand_total", "created_at", "updated_at" ]
end

def self.ransackable_associations(auth_object = nil)
  [ "user", "order_items" ]
end
end
