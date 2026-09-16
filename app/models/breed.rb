class Breed < ApplicationRecord
    has_many :pets, dependent: :restrict_with_error

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :species, presence: true
end
