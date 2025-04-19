class RemovePriceAndDeliveryFrequencyFromSubscriptions < ActiveRecord::Migration[8.0]
  def change
    remove_column :subscriptions, :price, :decimal
    remove_column :subscriptions, :delivery_frequency, :string
  end
end
