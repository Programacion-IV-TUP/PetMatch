module Admin
  class MedicalRecordsController < ApplicationController
    before_action :set_pet_for_new, only: [ :new, :create ]
    before_action :set_medical_record, only: [ :edit, :update, :destroy ]

    def new
      @medical_record = @pet.medical_records.build
    end

    def create
      @medical_record = @pet.medical_records.build(medical_record_params)
      if @medical_record.save
        redirect_to admin_pet_path(@pet), notice: t(".success", default: "Registro médico guardado correctamente.")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @pet = @medical_record.pet
    end

    def update
      @pet = @medical_record.pet
      if @medical_record.update(medical_record_params)
        redirect_to admin_pet_path(@pet), notice: t(".success", default: "Registro médico actualizado correctamente.")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @pet = @medical_record.pet
      @medical_record.destroy
      redirect_to admin_pet_path(@pet), notice: t(".success", default: "Registro médico eliminado correctamente.")
    end

    private

    def set_pet_for_new
      @pet = Pet.find(params[:pet_id])
    end

    def set_medical_record
      @medical_record = MedicalRecord.find(params[:id])
    end

    def medical_record_params
      params.require(:medical_record).permit(:record_type, :title, :performed_at, :next_due_date, :notes)
    end
  end
end
