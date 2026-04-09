class Customer < ApplicationRecord
  has_one :token, dependent: :nullify
  has_many :quiz_attempts, dependent: :destroy
  has_many :section_progresses, dependent: :destroy
  has_many :lesson_progresses, dependent: :destroy

  validates :name, presence: true
  validates :locale, presence: true
end
