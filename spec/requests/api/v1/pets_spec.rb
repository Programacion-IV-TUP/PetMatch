require 'rails_helper'

RSpec.describe "Api::V1::Pets", type: :request do
  let!(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }
  let!(:address) { Address.create!(street: "Calle 7", number: "850", city: city) }
  let!(:shelter) { Shelter.create!(name: "Refugio Patitas", email: "patitas@refugio.org", address: address) }
  
  let!(:dog_breed) { Breed.create!(name: "Labrador", species: :dog) }
  let!(:cat_breed) { Breed.create!(name: "Siamés", species: :cat) }

  let!(:dog) { Pet.create!(name: "Milo", age_months: 24, gender: :male, size: :large, status: :available, breed: dog_breed, shelter: shelter) }
  let!(:cat) { Pet.create!(name: "Luna", age_months: 6, gender: :female, size: :small, status: :available, breed: cat_breed, shelter: shelter) }

  describe "GET /api/v1/pets" do
    context "con filtros aplicados" do
      it "retorna las mascotas que coinciden con especie, género y tamaño" do
        get "/api/v1/pets", params: { species: "dog", gender: "male", size: "large" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"]).to be_an(Array)
        expect(json["data"].length).to eq(1)
        expect(json["data"].first["name"]).to eq("Milo")
      end

      it "retorna un array vacío si no hay coincidencias" do
        get "/api/v1/pets", params: { species: "cat", size: "large" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["data"]).to be_empty
      end
    end
  end
end