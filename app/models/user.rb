class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :owner,      class_name: "User", foreign_key: :owner_id,      optional: true
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id, optional: true
  belongs_to :updated_by, class_name: "User", foreign_key: :updated_by_id, optional: true

  ### validations
  validates :code,      presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 64 }
  validates :uuid,      presence: true, uniqueness: true
  validates :is_active, inclusion: { in: [ true, false ] }
  validates :email,     presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates_format_of :email, with: /\A(\S+)@(.+)\.(\S+)\z/

  scope :active,   -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
end
