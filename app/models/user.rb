class User < ApplicationRecord

  # Deviseのモジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_many :tasks, dependent: :destroy
  has_many :task_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
