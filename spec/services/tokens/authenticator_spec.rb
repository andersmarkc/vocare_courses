require "rails_helper"

RSpec.describe Tokens::Authenticator do
  let(:admin) { create(:admin_user) }
  let(:authenticator) { described_class.new }

  describe "#authenticate" do
    context "with a valid unused token" do
      let(:token) { create(:token, created_by: admin) }

      it "requires name on first use" do
        result = authenticator.authenticate(code: token.code)

        expect(result.success?).to be false
        expect(result.error).to eq(:name_required)
      end

      it "creates customer and activates token on first use" do
        result = authenticator.authenticate(code: token.code, name: "Lars Jensen", email: "lars@test.dk")

        expect(result.success?).to be true
        expect(result.customer.name).to eq("Lars Jensen")
        expect(result.customer.email).to eq("lars@test.dk")
        expect(result.token.activated?).to be true
        expect(result.token.customer).to eq(result.customer)
      end
    end

    context "with an activated token" do
      let(:customer) { create(:customer) }
      let(:token) { create(:token, :activated, customer: customer, created_by: admin) }

      it "returns existing customer" do
        result = authenticator.authenticate(code: token.code)

        expect(result.success?).to be true
        expect(result.customer).to eq(customer)
      end
    end

    context "with invalid tokens" do
      it "returns not_found for unknown code" do
        result = authenticator.authenticate(code: "VOCARE-FAKE-CODE")

        expect(result.success?).to be false
        expect(result.error).to eq(:not_found)
      end

      it "returns revoked for revoked token" do
        token = create(:token, :revoked, created_by: admin)
        result = authenticator.authenticate(code: token.code)

        expect(result.success?).to be false
        expect(result.error).to eq(:revoked)
      end

      it "returns expired for expired token" do
        token = create(:token, :expired, created_by: admin)
        result = authenticator.authenticate(code: token.code)

        expect(result.success?).to be false
        expect(result.error).to eq(:expired)
      end
    end

    it "normalizes code to uppercase" do
      token = create(:token, code: "VOCARE-ABCD-1234", created_by: admin)
      result = authenticator.authenticate(code: "vocare-abcd-1234", name: "Test")

      expect(result.success?).to be true
    end
  end
end
