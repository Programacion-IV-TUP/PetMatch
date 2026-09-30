require 'rails_helper'

RSpec.describe "Api::V1::Enums", type: :request do
  describe "GET /api/v1/enums" do
    it "retorna la estructura anidada de enums por modelo" do
      get "/api/v1/enums"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["data"]).to have_key("pet")
      expect(json["data"]["pet"]["genders"]).to include("male", "female")
      expect(json["data"]["pet"]["sizes"]).to include("small", "medium", "large")
      expect(json["data"]["adoption_application"]["statuses"]).to include("pending", "approved")
    end
  end
end
