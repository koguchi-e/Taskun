class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, class_name: "TaskComment", dependent: :destroy
  has_many :favorites, dependent: :destroy

  after_initialize :set_default_completed, if: :new_record?

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # バリデーション
  validates :title, length: { maximum: 30 }, presence: true
  validates :keyword1, length: { maximum: 30 }, presence: true
  validates :keyword2, length: { maximum: 30 }, presence: true
  validates :keyword3, length: { maximum: 30 }, presence: true

  private

  def set_default_completed
    self.completed ||= false
    self.completed_at ||= nil 
  end
end
