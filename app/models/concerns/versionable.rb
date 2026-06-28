module Versionable
  extend ActiveSupport::Concern

  included do
    validates :version,      presence: true
    validates :is_finalised, inclusion: { in: [ true, false ] }
    validates :is_published, inclusion: { in: [ true, false ] }
    validates :is_template,  inclusion: { in: [ true, false ] }

    scope :by_version,    ->(v) { where(version: v) }
    scope :current,       -> { where(is_current: true) }
    scope :not_current,   -> { where(is_current: false) }
    scope :finalised,     -> { where(is_finalised: true) }
    scope :published,     -> { where(is_published: true) }
    scope :templates,     -> { where(is_template: true) }
  end

  def versioned? = true
end
