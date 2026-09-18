class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :shelter, optional: true
  belongs_to :address

  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum :role, {
    admin: "admin",
    shelter_manager: "shelter_manager",
    adopter: "adopter"
    }, validate: true

  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
