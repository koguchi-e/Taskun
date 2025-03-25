class TaskComment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create do
    notifications.create(user_id: task.user_id, read: false)
  end
end
