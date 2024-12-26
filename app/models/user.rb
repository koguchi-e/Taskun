class User < ApplicationRecord
  # Deviseのモジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 依存関係のあるtasksとimage
  has_many :tasks, dependent: :destroy
  has_one_attached :image

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
