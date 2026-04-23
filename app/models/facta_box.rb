class FactaBox < ApplicationRecord
  include HasRichText

  belongs_to :section

  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_validation :assign_default_position, on: :create

  sanitize_rich_text :body

  private

  def assign_default_position
    return if position.present?
    return unless section_id

    self.position = (FactaBox.where(section_id: section_id).maximum(:position) || 0) + 1
  end
end
