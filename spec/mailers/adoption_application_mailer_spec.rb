require "rails_helper"

RSpec.describe AdoptionApplicationMailer, type: :mailer do
  describe "application_submitted" do
    let(:mail) { AdoptionApplicationMailer.application_submitted }

    it "renders the headers" do
      expect(mail.subject).to eq("Application submitted")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "new_application_notice" do
    let(:mail) { AdoptionApplicationMailer.new_application_notice }

    it "renders the headers" do
      expect(mail.subject).to eq("New application notice")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "status_changed" do
    let(:mail) { AdoptionApplicationMailer.status_changed }

    it "renders the headers" do
      expect(mail.subject).to eq("Status changed")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
