require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'validaciones' do
    let!(:city) { City.create!(name: 'La Plata', state: 'Buenos Aires') }
    let!(:address) { Address.create!(street: 'Calle 7', number: '123', city: city) }
    let!(:shelter) { Shelter.create!(name: 'Refugio Patitas', phone: '+542214445566', email: 'info@patitas.org', address: address) }
    let!(:breed) { Breed.create!(name: 'Mestizo', species: :dog) }

    it "nombre debe estar presente" do
      pet = described_class.new(
        name: nil,
        breed: breed,
        shelter: shelter
      )

      expect(pet).not_to be_valid
      expect(pet.errors[:name]).to be_present
    end

    it "es válido con todos los atributos requeridos" do
      pet = described_class.new(
        name: 'Milo',
        age_months: 12,
        gender: :male,
        size: :medium,
        status: :available,
        breed: breed,
        shelter: shelter
      )

      expect(pet).to be_valid
    end
  end
end
