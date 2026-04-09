class QuizAttempt < ApplicationRecord
  belongs_to :quiz
  belongs_to :customer
  has_many :quiz_answers, dependent: :destroy

  validates :started_at, presence: true

  def completed?
    completed_at.present?
  end

  def evaluating?
    !completed? && quiz_answers.exists?
  end
end
