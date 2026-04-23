require "rails_helper"

RSpec.describe HasRichText, type: :model do
  let(:section) { create(:section) }

  describe "sanitize_rich_text callback" do
    it "strips disallowed tags like <script>" do
      section.update!(description: '<p>ok</p><script>alert(1)</script>')
      expect(section.reload.description).not_to include("<script>")
      expect(section.description).to include("<p>ok</p>")
    end

    it "strips on* event handler attributes" do
      section.update!(description: '<p onclick="hack()">click</p>')
      expect(section.reload.description).not_to include("onclick")
    end

    it "neutralizes javascript: href values" do
      section.update!(description: '<a href="javascript:alert(1)">bad</a>')
      expect(section.reload.description).not_to include("javascript:")
    end

    it "forces rel=noopener nofollow and target=_blank on links" do
      section.update!(description: '<a href="https://example.com">link</a>')
      html = section.reload.description
      expect(html).to include('rel="noopener nofollow"')
      expect(html).to include('target="_blank"')
    end

    it "preserves allowed tags and attributes" do
      section.update!(description: '<p><strong>bold</strong> <em>em</em></p><ul><li>item</li></ul>')
      html = section.reload.description
      expect(html).to include("<strong>bold</strong>")
      expect(html).to include("<em>em</em>")
      expect(html).to include("<ul>")
      expect(html).to include("<li>item</li>")
    end

    it "ignores blank values" do
      expect { section.update!(description: "") }.not_to raise_error
    end
  end
end
