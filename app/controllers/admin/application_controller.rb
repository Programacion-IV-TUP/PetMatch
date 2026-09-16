module Admin
  class ApplicationController < ::ApplicationController
    before_action :require_admin_access

    private

    def require_admin_access
      unless current_user&.role.in?([ "admin", "shelter_manager" ])
        redirect_to root_path, alert: "No tenés permisos para acceder al área administrativa."
      end
    end

    # Helper method to restrict actions to the admin
    def ensure_global_admin!
      redirect_to admin_root_path, alert: t("errors.unauthorized") unless current_user.admin?
    end

    # Helper method to query the manager's shelter
    def current_shelter
      @current_shelter = @current_shelter || (current_user.admin? ? nil : current_user.shelter)
    end
    helper_method :current_shelter
  end
end
