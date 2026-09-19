class MedicalRecord < ApplicationRecord
  belongs_to :pet

  enum :record_type, {
    vaccine: "vaccine",
    deworming: "deworming",
    surgery: "surgery",
    checkup: "checkup",
    treatment: "treatment"
  }, default: "vaccine"

  validates :record_type, presence: true
  validates :performed_at, presence: true
  validates :title, presence: true
end
