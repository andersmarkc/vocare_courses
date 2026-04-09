require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  let(:admin) { create(:admin_user) }

  describe "POST /api/v1/auth/login" do
    let(:token) { create(:token, created_by: admin) }

    it "authenticates with valid token and name" do
      post api_v1_auth_login_path, params: { code: token.code, name: "Lars Jensen" }, as: :json

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["customer"]["name"]).to eq("Lars Jensen")
      expect(json["first_login"]).to be true
    end

    it "returns error for invalid token" do
      post api_v1_auth_login_path, params: { code: "VOCARE-FAKE-CODE" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body["error"]).to be_present
    end

    it "returns error when name is missing on first use" do
      post api_v1_auth_login_path, params: { code: token.code }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/auth/me" do
    it "returns 401 when not authenticated" do
      get api_v1_auth_me_path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns customer data when authenticated" do
      customer = create(:customer)
      token = create(:token, :activated, customer: customer, created_by: admin)

      post api_v1_auth_login_path, params: { code: token.code }, as: :json
      get api_v1_auth_me_path, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["customer"]["name"]).to eq(customer.name)
    end
  end

  describe "DELETE /api/v1/auth/logout" do
    it "clears the session" do
      customer = create(:customer)
      token = create(:token, :activated, customer: customer, created_by: admin)

      post api_v1_auth_login_path, params: { code: token.code }, as: :json
      delete api_v1_auth_logout_path, as: :json

      expect(response).to have_http_status(:no_content)

      get api_v1_auth_me_path, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
