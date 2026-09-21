module Admin
  class CitiesController < ApplicationController
    before_action :set_city, only: %i[destroy]
    before_action :authorize_admin!, only: %i[destroy] # Solo el Admin puede eliminar

    def index
      @cities = City.order(:name)
      @city = City.new
    end

    def create
      @city = City.new(city_params)

      if @city.save
        redirect_to admin_cities_path, notice: t(".success")
      else
        @cities = City.order(:name)
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      if @city.destroy
        redirect_to admin_cities_path, notice: t(".success")
      else
        redirect_to admin_cities_path, alert: t(".cannot_delete")
      end
    end

    private

    def set_city
      @city = City.find(params[:id])
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to admin_cities_path, alert: t("admin.shared.unauthorized")
      end
    end

    def city_params
      params.require(:city).permit(:name, :state)
    end
  end
end
