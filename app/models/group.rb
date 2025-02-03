class Group < ApplicationRecord
    belongs_to :owner, class_name: "User"
    has_one_attached :image

    validates :name, length: { maximum: 30 }, presence: true
    validates :summary, length: { maximum: 100 }
end
