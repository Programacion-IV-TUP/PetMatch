class AdoptionApplicationMailer < ApplicationMailer
  def application_submitted(application, locale: I18n.locale)
    @application = application
    @user = application.user
    @pet = application.pet

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t("mailers.adoption_application.submitted.subject", pet_name: @pet.name)
      )
    end
  end

  def new_application_notice(application, locale: I18n.locale)
    @application = application
    @pet = application.pet
    @shelter = @pet.shelter
    @managers = @shelter.users.where(role: :shelter_manager, active: true)

    return if @managers.empty?

    with_locale(locale) do
      mail(
        to: @managers.pluck(:email_address),
        subject: t("mailers.adoption_application.new_notice.subject", pet_name: @pet.name)
      )
    end
  end

  def status_changed(application, locale: I18n.locale)
    @application = application
    @user = application.user
    @pet = application.pet

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t("mailers.adoption_application.status_changed.subject", pet_name: @pet.name)
      )
    end
  end
end
