class Quiz < ApplicationRecord
  belongs_to :quizzable, polymorphic: true
  has_many :quiz_questions, -> { order(:position) }, dependent: :destroy, inverse_of: :quiz
  has_many :quiz_attempts, dependent: :destroy

  validates :title, presence: true
  validates :passing_score, presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
