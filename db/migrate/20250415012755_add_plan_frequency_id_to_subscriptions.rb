class AddPlanFrequencyIdToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_reference :subscriptions, :plan_frequency, null: false, foreign_key: true
  end
end
