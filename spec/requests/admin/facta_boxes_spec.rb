require "rails_helper"

RSpec.describe "Admin::FactaBoxes", type: :request do
  let(:admin) { create(:admin_user) }
  let(:section) { create(:section) }

  context "without admin auth" do
    it "redirects to sign in on new" do
      get new_admin_section_facta_box_path(section)
      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end

  context "with admin auth" do
    before { sign_in admin }

    it "creates a facta box" do
      expect {
        post admin_section_facta_boxes_path(section), params: {
          facta_box: { title: "Tip", body: "<p>Brug åbne spørgsmål</p>" }
        }
      }.to change { section.facta_boxes.count }.by(1)

      expect(response).to redirect_to(admin_section_path(section))
      expect(section.facta_boxes.last.title).to eq("Tip")
    end

    it "updates a facta box" do
      box = create(:facta_box, section: section, title: "Old")
      patch admin_section_facta_box_path(section, box), params: {
        facta_box: { title: "New" }
      }
      expect(box.reload.title).to eq("New")
      expect(response).to redirect_to(admin_section_path(section))
    end

    it "destroys a facta box" do
      box = create(:facta_box, section: section)
      expect {
        delete admin_section_facta_box_path(section, box)
      }.to change { section.facta_boxes.count }.by(-1)
    end
  end
end
