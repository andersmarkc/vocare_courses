require "rails_helper"

RSpec.describe "Api::V1::Lessons", type: :request do
  let(:admin) { create(:admin_user) }
  let(:customer) { create(:customer) }
  let(:token) { create(:token, :activated, customer: customer, created_by: admin) }
  let(:course) { create(:course) }
  let(:section) { create(:section, course: course, position: 1) }
  let(:lesson) { create(:lesson, section: section, intro: "<p>Hej</p>") }

  before do
    post api_v1_auth_login_path, params: { code: token.code }, as: :json
  end

  describe "GET /api/v1/lessons/:id" do
    it "includes the intro field" do
      get api_v1_lesson_path(lesson), as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["lesson"]["intro"]).to include("Hej")
    end
  end
end
