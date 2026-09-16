class Pet < ApplicationRecord
  belongs_to :shelter
  belongs_to :breed

  has_many :medical_records, dependent: :destroy
  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum :status, {
    available: "available",
    in_process: "in_process",
    adopted: "adopted"
  }, default: "available"

  validates :name, presence: true
  validates :gender, presence: true
  validates :age_months, presence: true
  validates :size, presence: true
end
