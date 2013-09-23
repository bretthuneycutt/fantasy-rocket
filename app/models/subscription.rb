class Subscription < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {scope: :canceled_at, messaage: "should have only one subscription at a time"}
  belongs_to :user

  scope :active, -> { where(canceled_at: nil) }
  scope :canceled, -> { where('canceled_at IS NOT NULL') }

  def canceled?
    !!canceled_at
  end

  def cancel!(expires_from_epoch = 0)
    self.canceled_at = Time.now
    self.expires_at = Time.at(expires_from_epoch.to_i).to_datetime
    save!
  end

  def expired?
    canceled? && expires_at < Time.now
  end
end
