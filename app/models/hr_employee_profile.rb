class HrEmployeeProfile < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  unloadable

  belongs_to :user
  belongs_to :supervisor, :class_name => "User"

  has_many :hr_holiday_modifiers
  has_many :hr_holiday_requests
  has_many :hr_employee_children

  def as_json(options = {})
    data = super :root => false
    data[:user] = user.as_json(:root => false)
    data[:supervisor] = supervisor.as_json(:root => false)
    data[:holiday_modifiers] = hr_holiday_modifiers.map(&:as_json)
    data[:employee_children] = hr_employee_children.map(&:as_json)
    data
  end
end
