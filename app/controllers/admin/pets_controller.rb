module Admin
  class PetsController < ApplicationController
    before_action :set_pet, only: %i[show edit update destroy purge_photo]

def index
      pets = scoped_pets
               .includes(:breed, :shelter)
               .search_by_name(params[:query])
               .by_status(params[:status])
               .by_active_status(params[:active])
               .order(created_at: :desc)

      @pagy, @pets = pagy(pets, items: 10)
    end

    def show
      # Adds the relations to generate fast access in the admin panel
      @pagy_adoption_applications, @adoption_applications = pagy(
        @pet.adoption_applications.includes(:user).order(created_at: :desc),
        items: 5,
        page_param: :adoption_applications_page
      )
      @pagy_medical_records, @medical_records = pagy(
        @pet.medical_records.order(performed_at: :desc),
        items: 5,
        page_param: :medical_records_page
      )
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
      new_photos = params[:pet].delete(:photos)

      if @pet.update(pet_params)
        # If new photos are being uploaded, append them to the existing collection.
        if new_photos.present?
          new_photos.reject(&:blank?).each do |photo|
            @pet.photos.attach(photo) if @pet.photos.count < 5
          end
        end

        redirect_to admin_pets_path, notice: t(".success")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # Deletes a specific photo from a pet
    def purge_photo
      photo = @pet.photos.find_by(id: params[:photo_id])

      if photo
        photo.purge
        redirect_to edit_admin_pet_path(@pet), notice: t(".photo_deleted")
      else
        redirect_to edit_admin_pet_path(@pet), alert: t(".photo_not_found")
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
        :name, :age_months, :gender, :size, :weight, :description, :status, :breed_id, :shelter_id, :active
      )
    end
  end
end
