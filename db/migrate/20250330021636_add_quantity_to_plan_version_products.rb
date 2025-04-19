class AddQuantityToPlanVersionProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :plan_version_products, :quantity, :integer
  end
end
