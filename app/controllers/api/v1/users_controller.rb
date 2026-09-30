module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: :create
      wrap_parameters false # Evita que ParamsWrapper intercepte y ensucie params[:user]

      # POST /api/v1/signup
      def create
        # Extracción segura tanto de parámetros planos como anidados bajo 'user'
        raw_user = params[:user].presence || params
        raw_address = raw_user[:address] || raw_user[:address_attributes] || params[:address]

        user = User.new(
          first_name: raw_user[:first_name],
          last_name: raw_user[:second_name] || raw_user[:last_name],
          email_address: raw_user[:email] || raw_user[:email_address],
          password: raw_user[:password],
          password_confirmation: raw_user[:password_confirmation] || raw_user[:password],
          phone: raw_user[:phone] || raw_user[:phone_number]
        )
        user.role = :adopter
        user.active = true

        # Construcción explícita de la dirección requerida
        if raw_address.present?
          user.build_address(
            street: raw_address[:street],
            number: raw_address[:number],
            floor: raw_address[:floor],
            apartment: raw_address[:apartment],
            zip_code: raw_address[:zip_code],
            city_id: raw_address[:city_id]
          )
        elsif raw_user[:address_id].present?
          user.address_id = raw_user[:address_id]
        else
          user.errors.add(:address, "is required")
          return render json: {
            status: 422,
            code: "VALIDATION_ERROR",
            errors: user.errors.as_json
          }, status: :unprocessable_entity
        end

        if user.save
          UserMailer.welcome(user).deliver_later if defined?(UserMailer)

          token = JsonWebToken.encode(sub: user.id, role: user.role)

          render json: {
            status: 201,
            data: {
              token: token,
              user: user_payload(user)
            }
          }, status: :created
        else
          # Devuelve los errores exactos de Active Record (ej. email duplicate, address invalid, short password)
          render json: {
            status: 422,
            code: "VALIDATION_ERROR",
            errors: user.errors.as_json.merge(user.address&.errors&.as_json || {})
          }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/profile
      def show
        render json: {
          status: 200,
          data: user_payload(current_user)
        }, status: :ok
      end

      private

      def user_payload(user)
        {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email_address,
          phone: user.phone,
          role: user.role,
          address: user.address ? {
            id: user.address.id,
            street: user.address.street,
            number: user.address.number,
            floor: user.address.floor,
            apartment: user.address.apartment,
            zip_code: user.address.zip_code,
            city_id: user.address.city_id,
            city: user.address.city&.name
          } : nil
        }
      end
    end
  end
end
