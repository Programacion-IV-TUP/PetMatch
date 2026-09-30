module Api
  module V1
    class EnumsController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /api/v1/enums
      def index
        render json: {
          status: 200,
          data: {
            breed: {
              species: Breed.species.keys
            },
            pet: {
              genders: Pet.genders.keys,
              sizes: Pet.sizes.keys,
              statuses: Pet.statuses.keys
            },
            adoption_application: {
              statuses: AdoptionApplication.statuses.keys
            },
            user: {
              roles: User.roles.keys
            }
          }
        }, status: :ok
      end
    end
  end
end
