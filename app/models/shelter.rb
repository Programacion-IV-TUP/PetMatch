class Shelter < ApplicationRecord
  belongs_to :address, autosave: true

  has_many :users
  has_many :pets, dependent: :destroy
  has_many :adoption_applications, through: :pets
  has_many :medical_records, through: :pets
  has_one_attached :logo
  has_many_attached :photos

  accepts_nested_attributes_for :address, update_only: true

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :photos, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }, limit: { max: 5 }
  validates :logo, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }

  # Soft delete scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Search & Filter scopes
  scope :search_by_text, ->(query) {
    if query.present?
      pattern = "%#{query.downcase}%"
      where("LOWER(name) LIKE :q OR LOWER(phone) LIKE :q", q: pattern)
    end
  }

  scope :by_active_status, ->(active_param) {
    case active_param
    when "true"  then active
    when "false" then inactive
    else all
    end
  }
end
