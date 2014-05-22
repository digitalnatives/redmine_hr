class EmployeeProfile < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :supervisor, :class_name => "User"

  has_many :holiday_modifiers
end
