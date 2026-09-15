class Shelter < ApplicationRecord
  belongs_to :address
  
  has_many :users
  has_many :pets, dependent: :destroy

  validates :name, precense: true
  validates :email, precense: true
  validates :phone, precense: true
end
