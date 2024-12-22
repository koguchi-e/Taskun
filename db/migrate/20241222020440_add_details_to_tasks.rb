class AddDetailsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :title, :string
    add_column :tasks, :keyword1, :string
    add_column :tasks, :keyword2, :string
    add_column :tasks, :keyword3, :string
  end
end
