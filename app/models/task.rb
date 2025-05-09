class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, class_name: "TaskComment", dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :notifications, as: :notifiable, dependent: :destroy

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  after_create do
    user.followers.each do |follower|
      notifications.create(user_id: follower.id)
    end
  end

  # バリデーション
  validates :title, length: { maximum: 30 }, presence: true
  validates :keyword1, length: { maximum: 30 }, presence: true
  validates :keyword2, length: { maximum: 30 }, presence: true
  validates :keyword3, length: { maximum: 30 }, presence: true

  enum status: { incomplete: 0, complete: 1 }
end
