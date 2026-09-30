module Api
  module V1
    class PetsController < ApplicationController
      include Rails.application.routes.url_helpers

      skip_before_action :authenticate_user!, only: %i[index show]

      # GET /api/v1/pets
      def index
        pets = Pet.active.includes(:breed, shelter: { address: :city }).where(status: :available)

        pets = pets.joins(:breed).where(breeds: { species: params[:species] }) if params[:species].present?
        pets = pets.where(breed_id: params[:breed_id]) if params[:breed_id].present?
        pets = pets.where(gender: params[:gender]) if params[:gender].present? # <--- Filtro agregado
        pets = pets.where(size: params[:size]) if params[:size].present?
        pets = pets.where(shelter_id: params[:shelter_id]) if params[:shelter_id].present?
        pets = pets.joins(shelter: :address).where(addresses: { city_id: params[:city_id] }) if params[:city_id].present?

        user_fav_ids = current_user ? current_user.favorites.pluck(:pet_id) : []

        render json: {
          status: 200,
          data: pets.map { |pet| pet_index_payload(pet, user_fav_ids) }
        }, status: :ok
      end

      # GET /api/v1/pets/:id
      def show
        pet = Pet.active.find_by(id: params[:id])

        if pet
          render json: {
            status: 200,
            data: pet_detail_payload(pet)
          }, status: :ok
        else
          render json: { status: 404, code: "NOT_FOUND" }, status: :not_found
        end
      end

      private

      def pet_index_payload(pet, favorite_ids)
        first_photo = pet.photos.attached? ? pet.photos.first : nil

        {
          id: pet.id,
          name: pet.name,
          age_months: pet.age_months,
          gender: pet.gender,
          size: pet.size,
          status: pet.status,
          image_url: first_photo ? rails_blob_url(first_photo, only_path: true) : nil,
          shelter_name: pet.shelter.name,
          is_favorite: favorite_ids.include?(pet.id)
        }
      end

      def pet_detail_payload(pet)
        {
          id: pet.id,
          name: pet.name,
          age_months: pet.age_months,
          gender: pet.gender,
          size: pet.size,
          weight: pet.weight,
          description: pet.description,
          status: pet.status,
          images: pet.photos.attached? ? pet.photos.map { |p| rails_blob_url(p, only_path: true) } : [],
          breed: {
            id: pet.breed&.id,
            name: pet.breed&.name,
            species: pet.breed&.species
          },
          shelter: {
            id: pet.shelter.id,
            name: pet.shelter.name,
            city: pet.shelter.address&.city&.name,
            email: pet.shelter.email
          },
          medical_records: pet.medical_records.map do |mr|
            {
              title: mr.title,
              applied_at: mr.performed_at
            }
          end
        }
      end
    end
  end
end
