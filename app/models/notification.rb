class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def message
    case self.notifiable_type
    when "Task"
      "フォローしている #{self.notifiable.user.name}さん が 「#{self.notifiable.title}」 を投稿しました。"
    when "Favorite"
      "投稿した 「#{self.notifiable.task.title}」 が #{self.notifiable.user.name}さん にいいねされました。"
    when "Relationship"
      " #{self.notifiable.follower.name}さん にフォローされました。"
    when "TaskComment"
      " #{self.notifiable.user.name}さん が 「#{self.notifiable.task.title}」 にコメントしました。"
    end
  end
end
