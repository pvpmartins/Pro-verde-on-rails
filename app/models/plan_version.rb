class PlanVersion < ApplicationRecord
  belongs_to :plan
  has_many :plan_version_products, dependent: :destroy
  has_many :products, through: :plan_version_products

  scope :active, -> { where(active: true) }

  has_many :plan_version_products

  def as_custom_json
    {
      id: id,
      version_date: version_date,
      products: plan_version_products.map(&:as_custom_json)
    }
  end
end
