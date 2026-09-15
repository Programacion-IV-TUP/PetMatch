class MedicalRecord < ApplicationRecord
  belongs_to :pet
  
  validates :applied_at, precense: true
  validates :title, precense: true
end
