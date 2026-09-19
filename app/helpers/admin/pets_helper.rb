module Admin
  module PetsHelper
    def pet_back_link_attributes
      if params[:from_shelter_id].present?
        {
          path: admin_shelter_path(params[:from_shelter_id]),
          label: t("admin.pets.show.back_to_shelter", default: "← Volver al refugio")
        }
      elsif params[:from_application_id].present?
        {
          path: admin_adoption_application_path(params[:from_application_id]),
          label: t("admin.pets.show.back_to_application", default: "← Volver a la solicitud")
        }
      else
        {
          path: admin_pets_path,
          label: t("admin.shared.back", default: "← Volver al listado")
        }
      end
    end
  end
end
