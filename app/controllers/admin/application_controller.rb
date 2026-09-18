module Admin
  class ApplicationController < ::ApplicationController
    # require_authentication ya viene heredado desde ApplicationController
    before_action :require_admin_access
    layout "admin"

    private

    def current_user
      Current.session&.user
    end

    def require_admin_access
      # Evaluamos con Current.session&.user o el helper interno
      user = current_user
      unless user && (user.role == "admin" || user.role == "shelter_manager")
        redirect_to root_path, alert: "No tenés permisos para acceder al área administrativa."
      end
    end

    # Helper method to restrict actions to the admin
    def ensure_global_admin!
      redirect_to admin_root_path, alert: "No autorizado" unless current_user&.role == "admin"
    end

    # Helper method to query the manager's shelter
    def current_shelter
      return nil if current_user&.role == "admin"
      @current_shelter ||= current_user&.shelter
    end
    helper_method :current_shelter, :current_user
  end
end
