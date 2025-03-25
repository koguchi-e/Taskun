class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    case notification.notifiable_type
    when "Task"
      redirect_to task_path(notification.notifiable)
    when "Favorite"
      redirect_to task_path(notification.notifiable.task)
    when "Relationship"
      redirect_to user_path(notification.notifiable.follower)
    when "TaskComment"
      redirect_to task_path(notification.notifiable.task)
    end
  end
end
