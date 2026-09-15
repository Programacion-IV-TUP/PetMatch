module Admin
  class ApplicationController < ::ApplicationController
    before_action :require_admin_access

    private

    def require_admin_access
      unless current_user&.role.in?(["admin", "shelter_manager"])
        redirect_to root_path, alert: "No tenés permisos para acceder al área administrativa."
      end
    end

    def current_shelter
      @current_shelter = @current_shelter || (current_user.admin? ? nil : current_user.shelter)
    end
  end
end