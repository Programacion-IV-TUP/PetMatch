require 'rails_helper'

RSpec.describe Pet, type: :model do
    describe 'validaciones' do
        let(:city) { City.create!(name: 'La Plata') }
        let(:address) { Address.create!(street: 'Calle 7', number: '123', city: city) }
        let(:shelter) { Shelter.create!(name: 'Refugio Patitas', address: address) }
        let(:breed) { Breed.create!(name: 'Mestizo') }

        it "nombre debe estar presente" do
            pet = Pet.new(
                name: nil,
                breed: breed,
                shelter: shelter,
            )

            expect(pet).not_to be_valid
            expect(pet.errors[:name]).to be_present

        end

    end
end