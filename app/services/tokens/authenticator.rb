module Tokens
  class Authenticator
    Result = Struct.new(:customer, :token, :error, keyword_init: true) do
      def success?
        error.nil?
      end
    end

    def authenticate(code:, name: nil, email: nil, phone: nil, company: nil)
      token = Token.find_by(code: code&.strip&.upcase)

      return Result.new(error: :not_found) unless token
      return Result.new(error: :revoked) if token.revoked?
      return Result.new(error: :expired) if token.expired?

      customer = find_or_create_customer(token, name: name, email: email, phone: phone, company: company)
      return customer if customer.is_a?(Result) # error result

      Result.new(customer: customer, token: token)
    end

    private

    def find_or_create_customer(token, name:, email:, phone:, company:)
      if token.customer.present?
        token.customer
      else
        return Result.new(error: :name_required) if name.blank?

        customer = Customer.create!(
          name: name,
          email: email,
          phone: phone,
          company: company
        )
        token.update!(customer: customer, activated_at: Time.current)
        customer
      end
    end
  end
end
