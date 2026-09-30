require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }

  describe "POST /api/v1/signup" do
    let(:valid_attributes) do
      {
        first_name: "Santiago",
        last_name: "Matheu",
        email: "santiago@test.com",
        password: "password123",
        password_confirmation: "password123",
        phone: "+542211234567",
        address: {
          street: "Calle 7",
          number: "850",
          city_id: city.id
        }
      }
    end

    context "con datos válidos y header de idioma" do
      it "registra al usuario, devuelve status 201 y un token JWT" do
        post "/api/v1/signup", params: valid_attributes, headers: { "Accept-Language" => "es" }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json["status"]).to eq(201)
        expect(json["data"]["token"]).to be_present
        expect(json["data"]["user"]["email"]).to eq("santiago@test.com")
        expect(json["data"]["user"]["address"]["street"]).to eq("Calle 7")
      end
    end

    context "cuando falta la dirección obligatoria" do
      it "rechaza la petición con status 422 Unprocessable Entity" do
        invalid_attributes = valid_attributes.except(:address)

        post "/api/v1/signup", params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["code"]).to eq("VALIDATION_ERROR")
        expect(json["errors"]).to have_key("address")
      end
    end
  end
end