class SectionProgress < ApplicationRecord
  belongs_to :customer
  belongs_to :section

  validates :customer_id, uniqueness: { scope: :section_id }
end
