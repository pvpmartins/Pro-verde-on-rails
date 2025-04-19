class CreatePlanVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_versions do |t|
      t.references :plan, null: false, foreign_key: true
      t.date :version_date
      t.boolean :active

      t.timestamps
    end
  end
end
