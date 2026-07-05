class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def versioned? = false
end
