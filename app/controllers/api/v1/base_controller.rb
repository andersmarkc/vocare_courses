module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_customer!

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

      private

      def authenticate_customer!
        render_error("Ikke autoriseret", :unauthorized) unless current_customer
      end

      def current_customer
        @current_customer ||= Customer.find_by(id: session[:customer_id])
      end

      def render_error(message, status)
        render json: { error: message }, status: status
      end

      def render_not_found
        render_error("Ikke fundet", :not_found)
      end
    end
  end
end
