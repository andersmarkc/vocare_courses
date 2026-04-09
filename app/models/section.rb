class Section < ApplicationRecord
  belongs_to :course
  has_many :lessons, -> { order(:position) }, dependent: :destroy, inverse_of: :section
  has_one :quiz, as: :quizzable, dependent: :destroy
  has_many :section_progresses, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :course_id }
  validates :position, presence: true, uniqueness: { scope: :course_id }

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  private

  def generate_slug
    self.slug = title.parameterize
  end
end
