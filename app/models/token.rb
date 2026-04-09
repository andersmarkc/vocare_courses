class Token < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :created_by, class_name: "AdminUser"

  validates :code, presence: true, uniqueness: true

  scope :unused, -> { where(customer_id: nil, revoked_at: nil) }
  scope :active, -> { where.not(customer_id: nil).where(revoked_at: nil) }
  scope :revoked, -> { where.not(revoked_at: nil) }

  def activated?
    activated_at.present?
  end

  def revoked?
    revoked_at.present?
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def usable?
    !revoked? && !expired?
  end
end
