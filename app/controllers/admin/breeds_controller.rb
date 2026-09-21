module Admin
  class BreedsController < ApplicationController
    before_action :set_breed, only: %i[destroy]
    before_action :authorize_admin!, only: %i[destroy] # Solo el Admin puede eliminar

    def index
      @breeds = Breed.order(:name)
      @breed = Breed.new
    end

    def create
      @breed = Breed.new(breed_params)

      if @breed.save
        redirect_to admin_breeds_path, notice: t(".success")
      else
        @breeds = Breed.order(:name)
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      if @breed.destroy
        redirect_to admin_breeds_path, notice: t(".success")
      else
        redirect_to admin_breeds_path, alert: t(".cannot_delete")
      end
    end

    private

    def set_breed
      @breed = Breed.find(params[:id])
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to admin_breeds_path, alert: t("admin.shared.unauthorized")
      end
    end

    def breed_params
      params.require(:breed).permit(:name, :species)
    end
  end
end
