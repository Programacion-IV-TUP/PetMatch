class ApplicationMailer < ActionMailer::Base
  default from: "soporte@petmatch.com"
  layout "mailer"

  private

  def with_locale(locale = I18n.locale, &block)
    I18n.with_locale(locale, &block)
  end
end
