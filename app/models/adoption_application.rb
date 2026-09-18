class AdoptionApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :user

  enum :status, {
    pending: "pending",
    under_review: "under_review",
    approved: "approved",
    rejected: "rejected",
    cancelled: "cancelled"
  }, default: "pending"

  validates :has_another_pet, inclusion: { in: [ true, false ] }
  validates :housing_type, presence: true
  validates :status, presence: true
end
