class TaskComment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_many :notifications, as: :notifiable, dependent: :destroy
end
