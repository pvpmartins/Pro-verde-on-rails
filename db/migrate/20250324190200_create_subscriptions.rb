class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.string :delivery_frequency
      t.decimal :price
      t.integer :status

      t.timestamps
    end
  end
end
