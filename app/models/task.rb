class Task < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :title, presence: true
  validates :keyword1, length: { maximum: 50 }
  validates :keyword2, length: { maximum: 50 }
  validates :keyword3, length: { maximum: 50 }
end
