class Plan < ApplicationRecord
  has_many :plan_versions, dependent: :destroy
  has_many :products, through: :plan_versions
  has_many :plan_frequencies, dependent: :destroy 

  has_one :latest_plan_version, -> { order(version_date: :desc) }, class_name: 'PlanVersion'
  serialize :features, coder: JSON

  def serialized_data
    last_version = plan_versions.order(version_date: :desc).first
    return nil if last_version.nil?

    {
      id: id,
      name: name,
      price: price,
      latest_plan_version: {
        id: last_version.id,
        version_date: last_version.version_date,
        products: last_version.plan_version_products.map do |pvp|
          {
            quantity: pvp.quantity,
            id: pvp.product.id,
            name: pvp.product.name
          }
        end
      }
    }
  end

end
