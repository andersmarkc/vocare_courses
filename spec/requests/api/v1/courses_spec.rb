require "rails_helper"

RSpec.describe "Api::V1::Courses", type: :request do
  let(:admin) { create(:admin_user) }
  let(:customer) { create(:customer) }
  let(:token) { create(:token, :activated, customer: customer, created_by: admin) }
  let(:course) { create(:course, slug: "test-course") }
  let!(:section) { create(:section, course: course, position: 1) }

  before do
    post api_v1_auth_login_path, params: { code: token.code }, as: :json
  end

  describe "GET /api/v1/courses/:slug" do
    it "returns course with sections" do
      get api_v1_course_path(slug: course.slug), as: :json

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["course"]["title"]).to eq(course.title)
      expect(json["sections"].size).to eq(1)
      expect(json["sections"][0]["locked"]).to be false
    end

    it "returns 404 for unknown slug" do
      get api_v1_course_path(slug: "nonexistent"), as: :json

      expect(response).to have_http_status(:not_found)
    end
  end
end
