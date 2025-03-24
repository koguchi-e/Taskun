class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :task
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :task_id }

  after_create do
    create_notification(user_id: task.user_id)
  end
end
