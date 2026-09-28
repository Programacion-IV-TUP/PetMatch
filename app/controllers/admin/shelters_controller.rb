module Admin
  class SheltersController < ApplicationController
    before_action :set_shelter, only: %i[show edit update destroy]
    before_action :authorize_admin!, only: %i[index new create destroy]
    before_action :authorize_shelter_access!, only: %i[show edit update]

    def index
      shelters = Shelter.includes(address: :city)
                        .search_by_text(params[:query])
                        .by_active_status(params[:active])
                        .order(:name)

      @pagy, @shelters = pagy(shelters, items: 10)
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
      return if current_user.admin?
      return if current_user.shelter_manager? && current_user.shelter_id == @shelter.id

      redirect_to admin_root_path, alert: t("errors.unauthorized")
    end

    def shelter_params
      allowed_params = [
        :name,
        :phone,
        :website,
        :description,
        :logo,
        photos: [],
        address_attributes: %i[id street number floor apartment zip_code city_id]
      ]

      # Only super admins can toggle shelter active state
      allowed_params << :active if current_user&.admin?

      params.require(:shelter).permit(allowed_params)
    end
  end
end
