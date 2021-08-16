class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :microposts, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_one_base64_attached :avatar

  scope :by_name, -> (name) { where('name LIKE ?', "%#{name}%") }
  scope :by_tag, -> (tag_ids) { joins(:user_tags).where(user_tags: { tag_id: tag_ids }) }
end
