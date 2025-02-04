class Group < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_many :group_memberships, dependent: :destroy
    has_many :members, through: :group_memberships, source: :user

    has_one_attached :image

    validates :name, length: { maximum: 30 }, presence: true
    validates :image, presence: true
    validates :summary, length: { maximum: 100 }
end
