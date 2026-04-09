require "rails_helper"

RSpec.describe EvaluateQuizAttemptJob, type: :job do
  let(:customer) { create(:customer) }
  let(:quiz) { create(:quiz) }
  let(:question) { create(:quiz_question, quiz: quiz) }
  let(:attempt) { create(:quiz_attempt, quiz: quiz, customer: customer) }
  let!(:answer) { create(:quiz_answer, quiz_attempt: attempt, quiz_question: question) }

  it "evaluates answers and sets score" do
    stub_openai_evaluation(score: 85, passed: true, explanation: "Godt svar!")

    described_class.perform_now(attempt.id)

    attempt.reload
    answer.reload

    expect(answer.ai_score).to eq(85)
    expect(answer.passed).to be true
    expect(answer.evaluated?).to be true
    expect(attempt.completed?).to be true
    expect(attempt.score).to eq(85)
    expect(attempt.passed).to be true
  end
end
