module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: :create

      # POST /api/v1/login
      def create
        email = params[:email] || params.dig(:user, :email) || params[:email_address]
        password = params[:password] || params.dig(:user, :password)

        user = User.authenticate_by(email_address: email, password: password)

        if user
          if !user.active?
            render json: {
              status: 403,
              code: "ACCOUNT_INACTIVE"
            }, status: :forbidden
          else
            token = JsonWebToken.encode(sub: user.id, role: user.role)

            render json: {
              status: 200,
              data: {
                token: token,
                user: {
                  id: user.id,
                  first_name: user.first_name,
                  email: user.email_address,
                  role: user.role
                }
              }
            }, status: :ok
          end
        else
          render json: {
            status: 401,
            code: "INVALID_CREDENTIALS"
          }, status: :unauthorized
        end
      end

      # DELETE /api/v1/logout
      def destroy
        render json: {
          status: 200,
          code: "LOGOUT_SUCCESS"
        }, status: :ok
      end
    end
  end
end
