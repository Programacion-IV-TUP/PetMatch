module Api
  module V1
    class BreedsController < ApplicationController
      skip_before_action :authenticate_user!, only: :index

      # GET /api/v1/breeds
      def index
        breeds = Breed.all.map { |b| { id: b.id, name: b.name, species: b.species } }

        render json: {
          status: 200,
          data: breeds
        }, status: :ok
      end
    end
  end
end