class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }
  layout "auth"

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      if !user.active?
        flash.now[:alert] = t("sessions.account_inactive")
        render :new, status: :unauthorized
      elsif user.adopter?
        flash.now[:alert] = t("errors.unauthorized")
        render :new, status: :forbidden
      else
        start_new_session_for user
        redirect_to after_authentication_url
      end
    else
      flash.now[:alert] = t("sessions.invalid_credentials")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
