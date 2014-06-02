class HrHolidayModifier < ActiveRecord::Base
  unloadable

  scope :by_profile, ->(id) { where(hr_employee_profile_id: id) }

  scope :by_year, ->(date) {
    boy = date.beginning_of_year
    eoy = date.end_of_year
    where("year >= ? and year <= ?", boy, eoy)
  }

  def as_json(options = {})
    super :root => false
  end
end
