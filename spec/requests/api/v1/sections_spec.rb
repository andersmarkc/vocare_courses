require "rails_helper"

RSpec.describe "Api::V1::Sections", type: :request do
  let(:admin) { create(:admin_user) }
  let(:customer) { create(:customer) }
  let(:token) { create(:token, :activated, customer: customer, created_by: admin) }
  let(:course) { create(:course) }
  let(:section) { create(:section, course: course, position: 1) }

  before do
    post api_v1_auth_login_path, params: { code: token.code }, as: :json
  end

  describe "GET /api/v1/sections/:id" do
    it "includes facta_boxes ordered by position" do
      create(:facta_box, section: section, title: "Second", position: 2)
      create(:facta_box, section: section, title: "First", position: 1)

      get api_v1_section_path(section), as: :json

      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["facta_boxes"].map { |b| b["title"] }).to eq([ "First", "Second" ])
      expect(json["facta_boxes"].first.keys).to include("id", "title", "body", "position")
    end

    it "returns an empty array when no facta boxes exist" do
      get api_v1_section_path(section), as: :json

      expect(response.parsed_body["facta_boxes"]).to eq([])
    end
  end
end
