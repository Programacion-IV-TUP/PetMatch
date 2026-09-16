# app/controllers/admin/breeds_controller.rb
module Admin
  class BreedsController < ApplicationController
    before_action :ensure_global_admin!
    before_action :set_breed, only: %i[edit update destroy]

    def index
      @breeds = Breed.order(species: :asc, name: :asc)
    end

    def new
      @breed = Breed.new
    end

    def create
      @breed = Breed.new(breed_params)
      if @breed.save
        redirect_to admin_breeds_path, notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @breed.update(breed_params)
        redirect_to admin_breeds_path, notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @breed.destroy
        redirect_to admin_breeds_path, notice: t(".success")
      else
        redirect_to admin_breeds_path, alert: t("errors.has_dependencies")
      end
    end

    private

    def set_breed
      @breed = Breed.find(params[:id])
    end

    def breed_params
      params.require(:breed).permit(:name, :species)
    end
  end
end
