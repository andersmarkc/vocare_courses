class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :tokens, foreign_key: :created_by_id, dependent: :restrict_with_error, inverse_of: :created_by
end
