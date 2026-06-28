class User < ApplicationRecord
  # Virtual attribute for authenticating by either user code or email
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :assign_uuid, on: :create
  before_save :email_format

  belongs_to :owner,      class_name: "User", foreign_key: :owner_id,      optional: true
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id, optional: true
  belongs_to :updated_by, class_name: "User", foreign_key: :updated_by_id, optional: true

  ### validations
  validates :code,      presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 64 }
  validates :uuid,      uniqueness: true
  validates :is_active, inclusion: { in: [ true, false ] }
  validates :email, length: { maximum: 100 }
  validates_format_of :email, with: /\A(\S+)@(.+)\.(\S+)\z/, allow_blank: true
  validate :password_complexity

  scope :active,   -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}\z/
    errors.add :password, "Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end

  ### private functions definitions
  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def email_format
    self.email = email.downcase
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "lower(code) = :value OR lower(email) = :value", { value: login.downcase } ]).first
    elsif conditions.key?(:code) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
