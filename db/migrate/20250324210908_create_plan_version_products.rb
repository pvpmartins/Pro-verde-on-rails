class CreatePlanVersionProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_version_products do |t|
      t.references :plan_version, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
