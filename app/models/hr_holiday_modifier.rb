class HrHolidayModifier < ActiveRecord::Base
  unloadable

  scope :by_profile, ->(id) { where(hr_employee_profile_id: id) }
end
