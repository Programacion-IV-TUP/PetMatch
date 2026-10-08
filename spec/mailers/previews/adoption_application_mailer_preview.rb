# Preview all emails at http://localhost:3000/rails/mailers/adoption_application_mailer
class AdoptionApplicationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/adoption_application_mailer/application_submitted
  def application_submitted
    AdoptionApplicationMailer.application_submitted(AdoptionApplication.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/adoption_application_mailer/new_application_notice
  def new_application_notice
    AdoptionApplicationMailer.new_application_notice(AdoptionApplication.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/adoption_application_mailer/status_changed
  def status_changed
    AdoptionApplicationMailer.status_changed(AdoptionApplication.first, "pending")
  end
end
