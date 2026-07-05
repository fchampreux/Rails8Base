class Group < ApplicationRecord
  belongs_to :owner,      class_name: "User", foreign_key: :owner_id
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id
  belongs_to :updated_by, class_name: "User", foreign_key: :updated_by_id

  has_many :users_groups, dependent: :destroy
  has_many :users, through: :users_groups

  validates :code,      presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 64 }
  validates :uuid,      uniqueness: true
  validates :is_active, inclusion: { in: [ true, false ] }

  scope :active,   -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
end
