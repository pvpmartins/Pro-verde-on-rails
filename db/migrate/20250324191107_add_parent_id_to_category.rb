class AddParentIdToCategory < ActiveRecord::Migration[8.0]
  def change
    add_reference :categories, :category, null: true, foreign_key: true
  end
end
