class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :shelter, optional: true
  belongs_to :address

  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :first_name, precense: true
  validates :second_name, precense: true
  validates :email, precense: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin shelter_manager adopter] }
end
