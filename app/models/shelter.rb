class Shelter < ApplicationRecord
  belongs_to :address

  has_many :users
  has_many :pets, dependent: :destroy
  has_many :adoption_applications, through: :pets
  has_many :medical_records, through: :pets

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
