class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ### validations
  validates :code,  presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates_format_of :email, with: /\A(\S+)@(.+)\.(\S+)\z/
end
