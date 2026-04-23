require "rails_helper"

RSpec.describe FactaBox, type: :model do
  it { is_expected.to belong_to(:section) }
  it { is_expected.to validate_presence_of(:title) }

  describe "position default" do
    let(:section) { create(:section) }

    it "defaults position to 1 when section has no boxes" do
      box = section.facta_boxes.create!(title: "First", body: "<p>body</p>")
      expect(box.position).to eq(1)
    end

    it "increments position based on existing boxes" do
      create(:facta_box, section: section, position: 1)
      create(:facta_box, section: section, position: 2)
      box = section.facta_boxes.create!(title: "Third", body: "<p>body</p>")
      expect(box.position).to eq(3)
    end

    it "respects an explicit position" do
      box = section.facta_boxes.create!(title: "Explicit", body: "<p>body</p>", position: 7)
      expect(box.position).to eq(7)
    end
  end

  describe "sanitization" do
    it "strips script tags from body" do
      box = create(:facta_box, body: '<p>ok</p><script>alert(1)</script>')
      expect(box.reload.body).not_to include("<script>")
    end
  end
end
