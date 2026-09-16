# app/controllers/admin/cities_controller.rb
module Admin
  class CitiesController < ApplicationController
    before_action :ensure_global_admin!
    before_action :set_city, only: %i[edit update destroy]

    def index
      @cities = City.order(name: :asc)
    end

    def new
      @city = City.new
    end

    def create
      @city = City.new(city_params)
      if @city.save
        redirect_to admin_cities_path, notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @city.update(city_params)
        redirect_to admin_cities_path, notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @city.destroy
        redirect_to admin_cities_path, notice: t(".success")
      else
        redirect_to admin_cities_path, alert: t("errors.has_dependencies")
      end
    end

    private

    def set_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:name, :state)
    end
  end
end
