module Admin
  module AdoptionApplicationsHelper
    def adoption_application_back_link_attributes
      return_to = params[:return_to].presence

      path = if return_to && return_to.start_with?("/") && !return_to.start_with?("//")
               return_to
      else
               admin_adoption_applications_path
      end

      {
        label: t("admin.shared.back"),
        path: path
      }
    end
  end
end
