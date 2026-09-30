require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_manager" do
    let(:mail) { described_class.welcome_manager }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome manager")
      expect(mail.to).to eq([ "to@example.org" ])
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "account_deactivated" do
    let(:mail) { described_class.account_deactivated }

    it "renders the headers" do
      expect(mail.subject).to eq("Account deactivated")
      expect(mail.to).to eq([ "to@example.org" ])
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
