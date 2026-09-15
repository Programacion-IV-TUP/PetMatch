class Address < ApplicationRecord
  belongs_to :city

  has_many :shelters
  has_many :users
  
  validates :street, presence: true
  validates :number, presence: true
end
