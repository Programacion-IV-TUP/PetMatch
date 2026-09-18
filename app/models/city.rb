class City < ApplicationRecord
    has_many :addresses, dependent: :restrict_with_error

    validates :name, presence: true, uniqueness: { scope: :state, case_sensitive: false }
    validates :state, presence: true
end
