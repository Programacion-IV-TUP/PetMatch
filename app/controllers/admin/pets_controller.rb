module Admin
  class PetsController < ApplicationController
    before_action :set_pet, only: %i[show edit update destroy]

    def index
      @pets = scoped_pets.includes(:breed, :shelter)
    end

    def show
      # Adds the relations to generate fast access in the admin panel
      @adoption_applications = @pet.adoption_applications.includes(:user).order(created_at: :desc)
      @medical_records = @pet.medical_records.order(applied_at: :desc)
    end

    def new
      @pet = scoped_pets.build
    end

    def create
      @pet = scoped_pets.build(pet_params)

      if @pet.save
        redirect_to admin_pet_path(@pet), notice: t(".success")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @pet.update(pet_params)
        redirect_to admin_pet_path(@pet), notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @pet.destroy
      redirect_to admin_pets_path, notice: t(".success")
    end

    private

    # Restricts the pet collection based on current user authorization:
    # - Admins get access to all pets.
    # - Shelter managers are scoped exclusively to their assigned shelter.
    def scoped_pets
      current_user.admin? ? Pet.all : current_shelter.pets
    end

    # Finds a pet within the user's scope
    def set_pet
      @pet = scoped_pets.find(params[:id])
    end

    def pet_params
      params.require(:pet).permit(
        :name, :age_months, :gender, :size, :weight, :description, :status, :breed_id, :shelter_id, photos: [])
    end
  end
end
