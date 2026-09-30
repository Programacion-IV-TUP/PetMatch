class UserMailer < ApplicationMailer
  def welcome(user, locale: I18n.locale)
    @user = user
    @shelter = user.shelter

    subject_key = if @user.shelter_manager?
                    "mailers.user.welcome.manager_subject"
    else
                    "mailers.user.welcome.adopter_subject"
    end

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t(subject_key)
      )
    end
  end

  def account_deactivated(user, locale: I18n.locale)
    @user = user

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t("mailers.user.account_deactivated.subject")
      )
    end
  end

  def account_reactivated(user, locale: I18n.locale)
    @user = user

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t("mailers.user.account_reactivated.subject")
      )
    end
  end
end
