class User < ApplicationRecord
  # Virtual attribute for authenticating by either user code or email
  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable

  attribute :is_active, :boolean, default: false
  attribute :is_admin,  :boolean, default: false

  before_save :email_format

  # User is the root of the ownership chain, so it can't require owner/created_by/updated_by
  # to already exist like every other model does (see app/models/CLAUDE.md) — a brand new
  # self-registering user, or the bootstrap admin, has to be able to reference itself.
  # optional: true skips Rails' association-must-exist check; presence below still enforces
  # that the columns are set, and the DB-level NOT NULL/FK constraints stay authoritative.
  belongs_to :owner,      class_name: "User", foreign_key: :owner_id,      optional: true
  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id, optional: true
  belongs_to :updated_by, class_name: "User", foreign_key: :updated_by_id, optional: true

  before_validation :self_reference_ownership, on: :create

  has_many :users_groups, dependent: :destroy
  has_many :groups, through: :users_groups
  has_one :main_users_group, -> { where(is_main_group: true) }, class_name: "UsersGroup"
  has_one :main_group, through: :main_users_group, source: :group

  ### validations
  validates :code,          presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 64 }
  validates :uuid,          uniqueness: true
  validates :owner_id,      presence: true
  validates :created_by_id, presence: true
  validates :updated_by_id, presence: true
  validates :is_active,     inclusion: { in: [ true, false ] }
  validates :is_admin,      inclusion: { in: [ true, false ] }
  validates :email,         presence: true, length: { maximum: 255 }, format: { with: /\A(\S+)@(.+)\.(\S+)\z/ }
  validate :password_complexity

  scope :active,   -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  scope :admin,    -> { where(is_admin: true) }
  scope :search,   ->(term) {
    pattern = "%#{sanitize_sql_like(term)}%"
    where("code ILIKE :t OR first_name ILIKE :t OR last_name ILIKE :t OR email ILIKE :t", t: pattern)
  }

  def devise_status
    return :locked if access_locked?
    confirmed? ? :confirmed : :unconfirmed
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}\z/
    errors.add :password, "Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end

  ### private functions definitions
  private

  def email_format
    self.email = email.downcase
  end

  # Self-registration (and the seed bootstrap user) has no existing user to point to,
  # so a brand new user owns itself. The id is reserved up front so it can be used as
  # owner_id/created_by_id/updated_by_id before the row is actually inserted.
  def self_reference_ownership
    return if owner_id.present? && created_by_id.present? && updated_by_id.present?

    self.id ||= self.class.connection.select_value(
      "SELECT nextval(pg_get_serial_sequence('users', 'id'))"
    ).to_i
    self.owner_id      ||= id
    self.created_by_id ||= id
    self.updated_by_id ||= id
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
