class AdoptionApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :user
  
  validates :has_another_pet, precense: true
  validates :housing_type, precense: true
  validates :status, precense:true
end
