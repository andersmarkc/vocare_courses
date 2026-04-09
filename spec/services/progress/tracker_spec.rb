require "rails_helper"

RSpec.describe Progress::Tracker do
  let(:customer) { create(:customer) }
  let(:course) { create(:course) }
  let(:tracker) { described_class.new(customer) }

  let!(:section1) { create(:section, course: course, position: 1) }
  let!(:section2) { create(:section, course: course, position: 2) }
  let!(:lesson1) { create(:lesson, section: section1, position: 1) }
  let!(:lesson2) { create(:lesson, section: section1, position: 2) }
  let!(:lesson3) { create(:lesson, section: section2, position: 1) }

  describe "#section_unlocked?" do
    it "always unlocks section 1" do
      expect(tracker.section_unlocked?(section1)).to be true
    end

    it "locks section 2 when section 1 is incomplete" do
      expect(tracker.section_unlocked?(section2)).to be false
    end

    it "unlocks section 2 when section 1 lessons are done and quiz passed" do
      create(:lesson_progress, :completed, customer: customer, lesson: lesson1)
      create(:lesson_progress, :completed, customer: customer, lesson: lesson2)
      quiz = create(:quiz, quizzable: section1)
      create(:quiz_attempt, :completed, customer: customer, quiz: quiz)

      expect(tracker.section_unlocked?(section2)).to be true
    end
  end

  describe "#course_progress" do
    it "returns progress summary" do
      create(:lesson_progress, :completed, customer: customer, lesson: lesson1)

      progress = tracker.course_progress(course)

      expect(progress[:total_lessons]).to eq(3)
      expect(progress[:completed_lessons]).to eq(1)
      expect(progress[:percentage]).to eq(33)
    end
  end
end
