class AddFeaturesToPlan < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :features, :text, default: '[]'
  end
end
