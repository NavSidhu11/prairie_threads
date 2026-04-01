class Product < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items
  has_many :orders, through: :order_items

  has_one_attached :image

  def thumb_image
  image.variant(resize_to_limit: [300, 300]) if image.attached?
end

def large_image
  image.variant(resize_to_limit: [900, 900]) if image.attached?
end

  validates :name, :description, presence: true
  validates :price, presence: true, numericality: true
  validates :stock_quantity, presence: true, numericality: { only_integer: true }

  scope :on_sale_only, -> { where(on_sale: true) }
  scope :new_only, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated_only, -> {
    where('updated_at >= ?', 3.days.ago)
      .where('created_at < ?', 3.days.ago)
  }

  def current_price
    on_sale && sale_price.present? ? sale_price : price
  end

def self.ransackable_attributes(auth_object = nil)
  ["id", "name", "description", "price", "stock_quantity", "on_sale", "sale_price", "created_at", "updated_at"]
end
def self.ransackable_associations(auth_object = nil)
  ["categories", "product_categories"]
end
end