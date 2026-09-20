# app/controllers/admin/shelters_controller.rb
module Admin
  class SheltersController < ApplicationController
    before_action :set_shelter, only: %i[show edit update destroy]
    before_action :authorize_admin!, only: %i[index new create destroy]
    before_action :authorize_shelter_access!, only: %i[show edit update]

    def index
      @shelters = Shelter.includes(address: :city).order(:name)
    end

    def show
    end

    def new
      @shelter = Shelter.new
      @shelter.build_address
    end

    def create
      @shelter = Shelter.new(shelter_params)
      if @shelter.save
        redirect_to admin_shelter_path(@shelter), notice: t(".success")
      else
        @shelter.build_address unless @shelter.address
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @shelter.build_address unless @shelter.address
    end

    def update
      if @shelter.update(shelter_params)
        # Si es admin de refugio, lo mantenemos en la vista de edición o de detalle de su refugio
        target_path = current_user.admin? ? admin_shelter_path(@shelter) : edit_admin_shelter_path(@shelter)
        redirect_to target_path, notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shelter.destroy
      redirect_to admin_shelters_path, notice: t(".success")
    end

    private

    def set_shelter
      @shelter = Shelter.find(params[:id])
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to admin_root_path, alert: t("errors.unauthorized")
      end
    end

    def authorize_shelter_access!
      # Permitir si es Admin general O si es Admin de refugio intentando modificar su propio refugio
      return if current_user.admin?
      return if current_user.shelter_manager? && current_user.shelter_id == @shelter.id

      redirect_to admin_root_path, alert: t("errors.unauthorized")
    end

    def shelter_params
      params.require(:shelter).permit(
        :name,
        :phone,
        :website,
        :description,
        :logo,
        photos: [],
        address_attributes: %i[id street number floor apartment zip_code city_id]
      )
    end
  end
end
