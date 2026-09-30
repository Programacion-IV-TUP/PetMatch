class PasswordsMailer < ApplicationMailer
  def reset(user, locale: I18n.locale)
    @user = user

    with_locale(locale) do
      mail(
        to: @user.email_address,
        subject: t("mailers.passwords.reset.subject")
      )
    end
  end
end
