require "rails_helper"

RSpec.describe Tokens::Generator do
  let(:admin) { create(:admin_user) }
  let(:generator) { described_class.new }

  describe "#generate" do
    it "creates a token with VOCARE-XXXX-XXXX format" do
      token = generator.generate(admin_user: admin)

      expect(token).to be_persisted
      expect(token.code).to match(/\AVOCARE-[A-Z0-9]{4}-[A-Z0-9]{4}\z/)
      expect(token.created_by).to eq(admin)
    end

    it "accepts label and expiry" do
      token = generator.generate(admin_user: admin, label: "Test", expires_at: 1.week.from_now)

      expect(token.label).to eq("Test")
      expect(token.expires_at).to be_within(1.second).of(1.week.from_now)
    end
  end

  describe "#batch_generate" do
    it "creates multiple unique tokens" do
      tokens = generator.batch_generate(admin_user: admin, count: 5)

      expect(tokens.size).to eq(5)
      codes = tokens.map(&:code)
      expect(codes.uniq.size).to eq(5)
    end
  end
end
