class City < ApplicationRecord
    has_many :addresses, dependent: :restrict_with_error

    validates :name, precence: true, uniqueness: { case_sensitive: false }
end
