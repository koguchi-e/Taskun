class Task < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :title, presence: true
  validates :keyword1, length: { maximum: 50 }, presence: true
  validates :keyword2, length: { maximum: 50 }, presence: true
  validates :keyword3, length: { maximum: 50 }, presence: true
end
