class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false # ポリモーフィック関連
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
