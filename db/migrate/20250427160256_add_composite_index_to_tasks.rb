class AddCompositeIndexToTasks < ActiveRecord::Migration[7.2]
  def change
    add_index :tasks, [:user_id, :status, :created_at]
  end
end
