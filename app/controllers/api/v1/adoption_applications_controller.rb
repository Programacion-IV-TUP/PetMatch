module Api
  module V1
    class AdoptionApplicationsController < ApplicationController
      include Rails.application.routes.url_helpers

      # GET /api/v1/adoption_applications
      def index
        applications = current_user.adoption_applications.includes(pet: :shelter)

        render json: {
          status: 200,
          data: applications.map { |app| application_payload(app) }
        }, status: :ok
      end

      # POST /api/v1/adoption_applications
      def create
        app_params = params[:adoption_application] || params

        pet = Pet.find_by(id: app_params[:pet_id])

        unless pet
          return render json: { status: 404, code: "NOT_FOUND" }, status: :not_found
        end

        unless pet.available?
          return render json: { status: 422, code: "PET_NOT_AVAILABLE" }, status: :unprocessable_entity
        end

        existing_app = current_user.adoption_applications.where(pet_id: pet.id, status: %w[pending under_review]).exists?
        if existing_app
          return render json: { status: 422, code: "DUPLICATE_APPLICATION" }, status: :unprocessable_entity
        end

        application = current_user.adoption_applications.build(
          pet: pet,
          housing_type: app_params[:housing_type],
          has_another_pet: app_params[:has_another_pet],
          notes: app_params[:notes],
          status: :pending
        )

        if application.save
          AdoptionApplicationMailer.application_submitted(application, locale: I18n.locale).deliver_later if defined?(AdoptionApplicationMailer)
          AdoptionApplicationMailer.new_application_notice(application, locale: I18n.locale).deliver_later if defined?(AdoptionApplicationMailer)

          render json: {
            status: 201,
            data: application_payload(application)
          }, status: :created
        else
          render json: {
            status: 422,
            code: "VALIDATION_ERROR",
            errors: application.errors.as_json
          }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/adoption_applications/:id
      def update
        application = current_user.adoption_applications.find_by(id: params[:id])
        return render json: { status: 404, code: "NOT_FOUND" }, status: :not_found unless application

        unless application.pending?
          return render json: { status: 422, code: "APPLICATION_NOT_EDITABLE" }, status: :unprocessable_entity
        end

        app_params = params[:adoption_application] || params

        if application.update(
          housing_type: app_params[:housing_type] || application.housing_type,
          has_another_pet: app_params.key?(:has_another_pet) ? app_params[:has_another_pet] : application.has_another_pet,
          notes: app_params[:notes] || application.notes
        )
          render json: { status: 200, data: application_payload(application) }, status: :ok
        else
          render json: { status: 422, code: "VALIDATION_ERROR", errors: application.errors.as_json }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/adoption_applications/:id (Cancel application)
      def destroy
        application = current_user.adoption_applications.find_by(id: params[:id])
        return render json: { status: 404, code: "NOT_FOUND" }, status: :not_found unless application

        if application.cancelled? || application.approved?
          return render json: { status: 422, code: "CANNOT_CANCEL_APPLICATION" }, status: :unprocessable_entity
        end

        application.update!(status: :cancelled)

        render json: { status: 200, code: "APPLICATION_CANCELLED" }, status: :ok
      end

      private

      def application_payload(application)
        first_photo = application.pet.photos.attached? ? application.pet.photos.first : nil

        {
          id: application.id,
          status: application.status,
          housing_type: application.housing_type,
          has_another_pet: application.has_another_pet,
          notes: application.notes,
          created_at: application.created_at,
          pet: {
            id: application.pet.id,
            name: application.pet.name,
            shelter_name: application.pet.shelter.name,
            image_url: first_photo ? rails_blob_url(first_photo, only_path: true) : nil
          }
        }
      end
    end
  end
end
