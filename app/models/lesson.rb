class Lesson < ApplicationRecord
  include HasRichText

  belongs_to :section
  has_many :lesson_progresses, dependent: :destroy
  has_one_attached :audio_file

  enum :content_type, { video: "video", audio: "audio", text: "text" }

  validates :title, presence: true
  validates :slug, presence: true
  validates :content_type, presence: true
  validates :position, presence: true, uniqueness: { scope: :section_id }
  validates :video_url, presence: true, if: :video?

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  sanitize_rich_text :body, :intro

  private

  def generate_slug
    self.slug = title.parameterize
  end
end
