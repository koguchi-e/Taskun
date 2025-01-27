class CreateTaskComments < ActiveRecord::Migration[6.1]
  def change
    create_table :task_comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
