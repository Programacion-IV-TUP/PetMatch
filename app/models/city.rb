class City < ApplicationRecord
    has_many :addresses
    
    validates :name, precence: true
end
