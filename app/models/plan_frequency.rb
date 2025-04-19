class PlanFrequency < ApplicationRecord
  belongs_to :plan
  has_one :subscription

  enum :frequency_type, {
    weekly: 0,
    biweekly: 1,
    monthly: 2,
    quarterly: 3,
    annually: 4
  }
  # Add any necessary validation and logic, such as ensuring only one frequency per plan
  validates :price, presence: true
  validates :frequency_type, uniqueness: { scope: :plan_id }
end
