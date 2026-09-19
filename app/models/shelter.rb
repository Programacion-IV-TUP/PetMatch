class Shelter < ApplicationRecord
  belongs_to :address

  has_many :users
  has_many :pets, dependent: :destroy
  has_many :adoption_applications, through: :pets
  has_many :medical_records, through: :pets
  has_one_attached :logo
  has_many_attached :photos

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :photos, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }, limit: { max: 5 }
  validates :logo, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }
end
