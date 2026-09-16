module Admin
  class SheltersController < ApplicationController
    before_action :ensure_global_admin!
    before_action :set_shelter, only: %i[show edit update destroy]

    def index
      @shelters = Shelter.all.order(name: :asc)
    end

    def new
      @shelter = Shelter.new
    end

    def create
      @shelter = Shelter.new(shelter_params)

      if @shelter.save
        redirect_to admin_shelter_path(@shelter), notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @shelter.update(shelter_params)
        redirect_to admin_shelter_path(@shelter), notice: t(".success")
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

    def shelter_params
      params.require(:shelter).permit(:name, :address, :phone, :email)
    end
  end
end
