class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, class_name: "TaskComment", dependent: :destroy

  # バリデーション
  validates :title, length: { maximum: 30 }, presence: true
  validates :keyword1, length: { maximum: 30 }, presence: true
  validates :keyword2, length: { maximum: 30 }, presence: true
  validates :keyword3, length: { maximum: 30 }, presence: true
end
