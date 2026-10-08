require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }
  let(:address) { Address.create!(street: "Calle 7", number: "123", city: city) }
  let(:admin) { User.create!(first_name: "Admin", last_name: "User", email_address: "admin@test.com", password: "password123", address: address, role: :admin) }
  let(:target_user) { User.create!(first_name: "Juan", last_name: "Pérez", email_address: "juan@test.com", password: "password123", address: address) }

  before do
    post session_path, params: { email_address: admin.email_address, password: "password123" }
  end

  describe "GET /admin/users" do
    it "returns http success" do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/:id" do
    it "returns http success" do
      get admin_user_path(target_user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/new" do
    it "returns http success" do
      get new_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/:id/edit" do
    it "returns http success" do
      get edit_admin_user_path(target_user)
      expect(response).to have_http_status(:success)
    end
  end
end