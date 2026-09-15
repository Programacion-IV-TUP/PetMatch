class Breed < ApplicationRecord
    has_many :pets
    
    validates :name, precense: true
    validates :species, precense: true
end
