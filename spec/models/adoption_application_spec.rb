require 'rails_helper'

RSpec.describe AdoptionApplication, type: :model do
  let!(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }
  let!(:address) { Address.create!(street: "Calle 7", number: "850", city: city) }
  let!(:shelter) { Shelter.create!(name: "Refugio Patitas", email: "patitas@refugio.org", phone: "+542214445566", address: address) }
  let!(:breed) { Breed.create!(name: "Mestizo", species: :dog) }
  let!(:pet) { Pet.create!(name: "Firulais", age_months: 12, gender: :male, size: :medium, status: :available, breed: breed, shelter: shelter) }

  let!(:adopter_a) { User.create!(first_name: "Juan", last_name: "Pérez", email_address: "juan@test.com", password: "password123", address: address) }
  let!(:adopter_b) { User.create!(first_name: "Maria", last_name: "Gómez", email_address: "maria@test.com", password: "password123", address: address) }

  describe "callbacks y reglas de negocio" do
    let!(:app_a) { AdoptionApplication.create!(pet: pet, user: adopter_a, housing_type: "house", has_another_pet: false) }
    let!(:app_b) { AdoptionApplication.create!(pet: pet, user: adopter_b, housing_type: "apartment", has_another_pet: true) }

    context "cuando se aprueba una solicitud de adopción" do
      it "cambia el estado de la mascota a 'adopted' y rechaza las solicitudes competidoras" do
        expect {
          app_a.update!(status: :approved)
        }.to change { pet.reload.status }.from("available").to("adopted")

        expect(app_b.reload.status).to eq("rejected")
        expect(app_b.notes).to include(I18n.t("admin.adoption_applications.auto_notes.rejected_by_adoption"))
      end
    end

    context "cuando se cancela una solicitud" do
      it "mantiene la mascota en estado 'available'" do
        app_a.update!(status: :cancelled)
        expect(pet.reload.status).to eq("available")
      end
    end
  end
end
