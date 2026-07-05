class UsersGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :is_active, inclusion: { in: [ true, false ] }

  scope :active,   -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
end
