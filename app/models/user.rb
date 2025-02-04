class User < ApplicationRecord

  # Deviseのモジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_many :tasks, dependent: :destroy
  has_many :task_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # オーナーとして所有するグループ
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  # 参加しているグループ
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
