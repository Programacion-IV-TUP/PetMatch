module Api
  module V1
    class SheltersController < ApplicationController
      skip_before_action :authenticate_user!, only: %i[index show]

      # GET /api/v1/shelters
      def index
        shelters = Shelter.active.includes(address: :city)

        render json: {
          status: 200,
          data: shelters.map { |shelter| shelter_payload(shelter) }
        }, status: :ok
      end

      # GET /api/v1/shelters/:id
      def show
        shelter = Shelter.active.find_by(id: params[:id])

        if shelter
          render json: {
            status: 200,
            data: shelter_payload(shelter, detailed: true)
          }, status: :ok
        else
          render json: { status: 404, code: "NOT_FOUND" }, status: :not_found
        end
      end

      private

      def shelter_payload(shelter, detailed: false)
        data = {
          id: shelter.id,
          name: shelter.name,
          email: shelter.email,
          phone: shelter.phone,
          website: shelter.website,
          city: shelter.address&.city&.name
        }

        if detailed
          data[:description] = shelter.description
          data[:address] = shelter.address ? {
            street: shelter.address.street,
            number: shelter.address.number,
            floor: shelter.address.floor,
            apartment: shelter.address.apartment,
            zip_code: shelter.address.zip_code
          } : nil
        end

        data
      end
    end
  end
end