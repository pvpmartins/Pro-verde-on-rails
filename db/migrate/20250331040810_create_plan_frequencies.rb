class CreatePlanFrequencies < ActiveRecord::Migration[8.0]
  def change
    create_table :plan_frequencies do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :frequency_type
      t.decimal :price

      t.timestamps
    end
  end
end
