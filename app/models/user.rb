class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :microposts, dependent: :destroy
  has_one_attached :avatar
end
