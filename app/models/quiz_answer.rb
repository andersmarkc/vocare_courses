class QuizAnswer < ApplicationRecord
  belongs_to :quiz_attempt
  belongs_to :quiz_question

  validates :student_answer, presence: true

  def evaluated?
    evaluated_at.present?
  end
end
