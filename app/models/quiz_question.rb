class QuizQuestion < ApplicationRecord
  belongs_to :quiz
  has_many :quiz_answers, dependent: :destroy

  validates :question_text, presence: true
  validates :expected_answer, presence: true
  validates :position, presence: true
  validates :points, presence: true, numericality: { greater_than: 0 }
end
