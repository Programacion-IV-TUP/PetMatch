require "rails_helper"

RSpec.describe AdoptionApplicationMailer, type: :mailer do
  let(:city) { City.create!(name: "La Plata", state: "Buenos Aires") }
  let(:address) { Address.create!(street: "Calle 7", number: "123", city: city) }
  let(:shelter) { Shelter.create!(name: "Refugio Patitas", phone: "+542214445566", email: "info@patitas.org", address: address) }
  let(:breed) { Breed.create!(name: "Mestizo", species: :dog) }
  let(:pet) { Pet.create!(name: "Firulais", age_months: 12, gender: :male, size: :medium, status: :available, breed: breed, shelter: shelter) }
  let(:user) { User.create!(first_name: "Juan", last_name: "Pérez", email_address: "juan@test.com", password: "password123", address: address) }
  let(:adoption_application) { AdoptionApplication.create!(pet: pet, user: user, housing_type: "house", has_another_pet: false) }

  describe "application_submitted" do
    let(:mail) { described_class.application_submitted(adoption_application) }

    it "renders the headers" do
      expect(mail.to).to eq([ user.email_address ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to be_present
    end
  end

  describe "new_application_notice" do
    before do
      User.create!(
        first_name: "Manager",
        last_name: "Refugio",
        email_address: "manager@patitas.org",
        password: "password123",
        role: :shelter_manager,
        active: true,
        shelter: shelter,
        address: address
      )
    end

    let(:mail) { described_class.new_application_notice(adoption_application) }

    it "renders the headers" do
      expect(mail).not_to be_nil
      expect(mail.subject).to be_present
    end

    it "renders the body" do
      expect(mail.body.encoded).to be_present
    end
  end

  describe "status_changed" do
    let(:mail) { described_class.status_changed(adoption_application) }

    it "renders the headers" do
      expect(mail.to).to eq([ user.email_address ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to be_present
    end
  end
end