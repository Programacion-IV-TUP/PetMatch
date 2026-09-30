module Api
  module V1
    class ApplicationController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from StandardError, with: :render_internal_server_error

      before_action :authenticate_user!

      attr_reader :current_user

      private

      def authenticate_user!
        authenticate_token || render_unauthorized
      end

      def authenticate_token
        authenticate_with_http_token do |token, _options|
          payload = JsonWebToken.decode(token)
          return nil unless payload

          user = User.find_by(id: payload[:sub])
          if user&.active?
            @current_user = user
          end
        end
      end

      def render_unauthorized
        render json: {
          status: 401,
          code: "UNAUTHORIZED"
        }, status: :unauthorized
      end

      def render_not_found(exception)
        render json: {
          status: 404,
          code: "NOT_FOUND"
        }, status: :not_found
      end

      def render_internal_server_error(exception)
        Rails.logger.error(exception.message)
        Rails.logger.error(exception.backtrace.join("\n"))

        render json: {
          status: 500,
          code: "INTERNAL_SERVER_ERROR"
        }, status: :internal_server_error
      end
    end
  end
end
