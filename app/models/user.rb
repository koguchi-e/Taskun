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

  # フォローする側
  # 中間テーブルへ
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 中間テーブルを通して、フォローされる側テーブルへ
  has_many :followings, through: :relationships, source: :followed

  # フォローされる側
  # 中間テーブルへ
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 中間テーブルを通して、フォローする側テーブルへ
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # ゲストログイン
  GUSEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUSEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def guest_user?
    email == GUSEST_USER_EMAIL
  end

  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [width, height]).processed
    else
      'default_profile_image.png'
    end
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
