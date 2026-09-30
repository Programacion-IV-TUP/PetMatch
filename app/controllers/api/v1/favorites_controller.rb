module Api
  module V1
    class FavoritesController < ApplicationController
      include Rails.application.routes.url_helpers

      # GET /api/v1/favorites
      def index
        favorites = current_user.favorites.includes(pet: :shelter)

        render json: {
          status: 200,
          data: favorites.map { |fav|
            first_photo = fav.pet.photos.attached? ? fav.pet.photos.first : nil
            {
              favorite_id: fav.id,
              pet: {
                id: fav.pet.id,
                name: fav.pet.name,
                age_months: fav.pet.age_months,
                image_url: first_photo ? rails_blob_url(first_photo, only_path: true) : nil
              }
            }
          }
        }, status: :ok
      end

      # POST /api/v1/favorites
      def create
        pet = Pet.find_by(id: params[:pet_id])

        return render json: { status: 404, code: "NOT_FOUND" }, status: :not_found unless pet

        favorite = current_user.favorites.find_or_initialize_by(pet: pet)

        if favorite.save
          render json: {
            status: 201,
            data: {
              pet_id: pet.id,
              user_id: current_user.id
            }
          }, status: :created
        else
          render json: {
            status: 422,
            code: "VALIDATION_ERROR",
            errors: favorite.errors.as_json
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/favorites/:id
      def destroy
        favorite = current_user.favorites.find_by(id: params[:id]) || current_user.favorites.find_by(pet_id: params[:id])

        if favorite
          favorite.destroy
          render json: {
            status: 200,
            code: "DELETED_SUCCESSFULLY"
          }, status: :ok
        else
          render json: { status: 404, code: "NOT_FOUND" }, status: :not_found
        end
      end
    end
  end
end
