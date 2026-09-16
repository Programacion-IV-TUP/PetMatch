class MedicalRecord < ApplicationRecord
  belongs_to :pet
  
  enum :record_type, {
    vaccine: "vaccine",
    deworming: "deworming",
    surgery: "surgery",
    checkup: "checkup",
    treatment: "treatment"
  }, default: "vaccine"

  validates :record_type, precense: true
  validates :applied_at, precense: true
  validates :title, precense: true
end
