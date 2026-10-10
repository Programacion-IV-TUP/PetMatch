module PetsHelper
  def pet_species_icon(pet)
    case pet.breed&.species&.downcase
    when "cat"
      "🐱"
    when "dog"
      "🐶"
    else
      "🐾"
    end
  end
end
