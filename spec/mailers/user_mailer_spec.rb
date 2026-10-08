require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }
  let(:address) { Address.create!(street: "Calle 7", number: "123", city: city) }
  let(:user) { User.create!(first_name: "Juan", last_name: "Pérez", email_address: "juan@test.com", password: "password123", address: address, role: :shelter_manager) }

  describe "welcome_manager" do
    let(:mail) { described_class.welcome(user) }

    it "renders the headers" do
      expect(mail.to).to eq([ user.email_address ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to be_present
    end
  end

  describe "account_deactivated" do
    let(:mail) { described_class.account_deactivated(user) }

    it "renders the headers" do
      expect(mail.to).to eq([ user.email_address ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to be_present
    end
  end
end