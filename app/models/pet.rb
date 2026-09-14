class Pet < ApplicationRecord
  belongs_to :breed
  belongs_to :shelter
  validates :name, presence: true
  validates :gender, presence: true
  validates :age_months, presence: true
  validates :size, presence: true
end
