class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    @shelter = user.shelter

    subject_key = if @user.shelter_manager?
      "mailers.user.welcome.manager_subject"
    else
      "mailers.user.welcome.adopter_subject"
    end

    mail(
      to: @user.email_address,
      subject: t(subject_key)
    )
  end

  def account_deactivated(user)
    @user = user

    mail(
      to: @user.email_address,
      subject: t("mailers.user.account_deactivated.subject")
    )
  end

  def account_reactivated(user)
    @user = user

    mail(
      to: @user.email_address,
      subject: t("mailers.user.account_reactivated.subject")
    )
  end
end
