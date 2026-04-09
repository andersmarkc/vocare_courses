module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_customer!, only: [ :login ]

      def login
        result = Tokens::Authenticator.new.authenticate(
          code: params[:code],
          name: params[:name],
          email: params[:email],
          phone: params[:phone],
          company: params[:company]
        )

        unless result.success?
          message = case result.error
          when :not_found then "Ugyldig adgangskode"
          when :revoked then "Denne adgangskode er deaktiveret"
          when :expired then "Denne adgangskode er udløbet"
          when :name_required then "Navn er påkrævet ved første login"
          end
          return render_error(message, :unauthorized)
        end

        session[:customer_id] = result.customer.id
        render json: {
          customer: customer_json(result.customer),
          first_login: result.token.activated_at >= 1.minute.ago
        }
      end

      def logout
        session.delete(:customer_id)
        head :no_content
      end

      def me
        tracker = Progress::Tracker.new(current_customer)
        course = Course.find_by(published: true)

        render json: {
          customer: customer_json(current_customer),
          progress: course ? tracker.course_progress(course) : nil
        }
      end

      private

      def customer_json(customer)
        {
          id: customer.id,
          name: customer.name,
          email: customer.email,
          company: customer.company,
          locale: customer.locale
        }
      end
    end
  end
end
