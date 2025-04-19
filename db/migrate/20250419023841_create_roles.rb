class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false

      # Product permissions
      t.boolean :can_create_product, default: false
      t.boolean :can_edit_product, default: false
      t.boolean :can_delete_product, default: false

      # Plan permissions
      t.boolean :can_create_plan, default: false
      t.boolean :can_edit_plan, default: false
      t.boolean :can_delete_plan, default: false

      # Subscription permissions (example)
      t.boolean :can_create_subscription, default: false
      t.boolean :can_edit_subscription, default: false
      t.boolean :can_delete_subscription, default: false

      # Admin access
      t.boolean :can_access_admin, default: false

      t.timestamps
    end
  end
end
