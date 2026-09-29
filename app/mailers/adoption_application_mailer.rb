class AdoptionApplicationMailer < ApplicationMailer
  def application_submitted(application)
    @application = application
    @user = application.user
    @pet = application.pet

    mail(
      to: @user.email_address,
      subject: t("mailers.adoption_application.submitted.subject", pet_name: @pet.name)
    )
  end

  def new_application_notice(application)
    @application = application
    @pet = application.pet
    @shelter = @pet.shelter
    @managers = @shelter.users.where(role: :shelter_manager, active: true)

    return if @managers.empty?

    mail(
      to: @managers.pluck(:email_address),
      subject: t("mailers.adoption_application.new_notice.subject", pet_name: @pet.name)
    )
  end

  def status_changed(application)
    @application = application
    @user = application.user
    @pet = application.pet

    mail(
      to: @user.email_address,
      subject: t("mailers.adoption_application.status_changed.subject", pet_name: @pet.name)
    )
  end
end
