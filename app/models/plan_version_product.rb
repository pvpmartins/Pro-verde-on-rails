class PlanVersionProduct < ApplicationRecord
    belongs_to :plan_version
    belongs_to :product

    validates :quantity, presence: true, numericality: { greater_than: 0 }

    def as_custom_json
      {
        quantity: quantity,
        product: {
          id: product.id,
          name: product.name
        }
      }
    end
end
