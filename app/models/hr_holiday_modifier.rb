class HrHolidayModifier < ActiveRecord::Base
  unloadable

  validates :year, :value, presence: true

  scope :by_profile, ->(id) { where(hr_employee_profile_id: id) }

  scope :by_year, ->(date) {
    boy = date.beginning_of_year
    eoy = date.end_of_year
    where("year >= ? and year <= ?", boy, eoy)
  }

  def as_json(options = {})
    data = super :root => false
    data[:year] = self.year.year
    data
  end
end
