# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome_manager
  def welcome_manager
    UserMailer.welcome_manager
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_deactivated
  def account_deactivated
    UserMailer.account_deactivated
  end

end
