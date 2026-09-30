module Api
  module V1
    class CitiesController < ApplicationController
      skip_before_action :authenticate_user!, only: :index

      # GET /api/v1/cities
      def index
        cities = City.all.map { |c| { id: c.id, name: c.name } }

        render json: {
          status: 200,
          data: cities
        }, status: :ok
      end
    end
  end
end