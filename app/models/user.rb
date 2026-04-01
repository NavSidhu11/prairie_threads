class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify

  validates :first_name, presence: true
  validates :last_name, presence: true
end