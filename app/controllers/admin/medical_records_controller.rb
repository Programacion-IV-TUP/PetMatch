module Admin
  class MedicalRecordsController < ApplicationController
    before_action :set_medical_record, only: %i[show edit update destroy]
    before_action :set_pet_for_new, only: %i[new create]

    def index
      @medical_records = scoped_medical_records.includes(:pet).order(applied_at: :desc)
    end

    def new
      @medical_record = @pet.medical_records.build
    end

    def create
      @medical_record = @pet.medical_records.build(medical_record_params)

      if @medical_record.save
        redirect_to admin_pet_path(@pet), notice: "Registro médico cargado exitosamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @medical_record.update(medical_record_params)
        redirect_to admin_pet_path(@medical_record.pet), notice: "Registro médico actualizado exitosamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      pet = @medical_record.pet
      @medical_record.destroy
      redirect_to admin_pet_path(pet), notice: "Registro médico eliminado."
    end

    private

    # Restricts medical records based on user role:
    # - Admins can manage medical records across all pets.
    # - Shelter managers can only manage records for pets in their assigned shelter.
    def scoped_medical_records
      if current_user.admin?
        MedicalRecord.all
      else
        current_shelter.medical_records
      end
    end

    # Finds a medical record within the user's scope.
    def set_medical_record
      @medical_record = scoped_medical_records.find(params[:id])
    end

    # Ensures that the target pet belongs to the user's scope before building a new record.
    def set_pet_for_new
      pet_scope = current_user.admin? ? Pet.all : current_shelter.pets
      @pet = pet_scope.find(params[:pet_id])
    end

    def medical_record_params
      params.require(:medical_record).permit(:record_type, :title, :description, :applied_at, :next_due_at)
    end
  end
end