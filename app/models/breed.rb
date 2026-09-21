class Breed < ApplicationRecord
    has_many :pets, dependent: :restrict_with_error

    enum :species, { dog: "dog", cat: "cat", other: "other" }

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :species, presence: true
end
