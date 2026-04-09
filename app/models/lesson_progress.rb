class LessonProgress < ApplicationRecord
  belongs_to :customer
  belongs_to :lesson

  validates :customer_id, uniqueness: { scope: :lesson_id }
end
