module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!, only: :create
      wrap_parameters false # Avoids ParamsWrapper intercepting and dirtying params[:user]

      # POST /api/v1/signup
      def create
        # Secure extraction both flat parameters and nested under 'user'
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

        # Explicit construction of the required address
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
          UserMailer.welcome(user, locale: I18n.locale).deliver_later if defined?(UserMailer)

          token = JsonWebToken.encode(sub: user.id, role: user.role)

          render json: {
            status: 201,
            data: {
              token: token,
              user: user_payload(user)
            }
          }, status: :created
        else
          # Returns the exact errors from Active Record
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

      # PUT/PATCH /api/v1/profile
      def update
        raw_user = params[:user].presence || params
        raw_address = raw_user[:address] || raw_user[:address_attributes]

        current_user.first_name = raw_user[:first_name] if raw_user[:first_name].present?
        current_user.last_name = raw_user[:second_name] || raw_user[:last_name] if raw_user[:second_name].present? || raw_user[:last_name].present?
        current_user.phone = raw_user[:phone] || raw_user[:phone_number] if raw_user[:phone].present? || raw_user[:phone_number].present?

        if raw_address.present?
          current_user.address ||= current_user.build_address
          current_user.address.assign_attributes(
            street: raw_address[:street] || current_user.address.street,
            number: raw_address[:number] || current_user.address.number,
            floor: raw_address[:floor] || current_user.address.floor,
            apartment: raw_address[:apartment] || current_user.address.apartment,
            zip_code: raw_address[:zip_code] || current_user.address.zip_code,
            city_id: raw_address[:city_id] || current_user.address.city_id
          )
        end

        if current_user.save
          render json: {
            status: 200,
            data: user_payload(current_user)
          }, status: :ok
        else
          render json: {
            status: 422,
            code: "VALIDATION_ERROR",
            errors: current_user.errors.as_json
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/profile (Soft delete)
      def destroy
        current_user.update(active: false)
        UserMailer.account_deactivated(current_user, locale: I18n.locale).deliver_later if defined?(UserMailer)

        render json: {
          status: 200,
          code: "ACCOUNT_DEACTIVATED"
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
