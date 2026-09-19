class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :shelter, optional: true
  belongs_to :address

  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :avatar

  enum :role, { admin: "admin", shelter_manager: "shelter_manager", adopter: "adopter" }, validate: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :avatar, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
