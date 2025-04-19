class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan_frequency

  delegate :plan, to: :plan_frequency

  enum :status, { active: 0, cancelled: 1, paused: 2 }

  def renew_subscription
    # Extend the subscription by one more month
    self.start_date = Time.current
    calculate_end_date
    self.status = :active
    save!
  end

  def cancel_subscription
    self.status = :cancelled
    save!
  end

  def as_json(options = {})
    super(options).merge(status: status)
  end

end

