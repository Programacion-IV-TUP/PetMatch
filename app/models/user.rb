class User < ApplicationRecord
  belongs_to :shelter, optional: true
  belongs_to :address

  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
