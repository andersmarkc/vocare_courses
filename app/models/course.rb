class Course < ApplicationRecord
  has_many :sections, -> { order(:position) }, dependent: :destroy, inverse_of: :course
  has_one :final_quiz, -> { where(quizzable_type: "Course") }, class_name: "Quiz", as: :quizzable, dependent: :destroy, inverse_of: :quizzable

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
end
