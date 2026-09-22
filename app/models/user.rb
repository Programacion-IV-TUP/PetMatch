class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :shelter, optional: true
  belongs_to :address, autosave: true

  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :avatar

  accepts_nested_attributes_for :address, update_only: true

  enum :role, { admin: "admin", shelter_manager: "shelter_manager", adopter: "adopter" }, default: "adopter", validate: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :avatar, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }
  validates :password, length: { minimum: 6 }, allow_nil: true, if: :password_required?

  # Soft delete scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Search & Filter scopes
  scope :search_by_text, ->(query) {
    if query.present?
      pattern = "%#{query.downcase}%"
      where("LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email_address) LIKE :q", q: pattern)
    end
  }

  scope :by_role, ->(role_param) { where(role: role_param) if role_param.present? }

  scope :by_active_status, ->(active_param) {
    case active_param
    when "true"  then active
    when "false" then inactive
    else all
    end
  }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def password_required?
    new_record? || password.present?
  end
end
