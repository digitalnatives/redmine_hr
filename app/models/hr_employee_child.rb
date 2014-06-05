class HrEmployeeChild < ActiveRecord::Base
  unloadable

  # reflections
  belongs_to :hr_employee_profile

  # validations
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :hr_employee_profile_id, presence: true
  validates :gender, inclusion: {in: %w{male female}}

  # scopes
  scope :by_employee_profile, ->(id) { where(hr_employee_profile_id: id) }

  def age
    ((Date.today.beginning_of_year - birth_date.beginning_of_year).to_i / 365)
  end

  def as_json(options = {})
    super :root => false
  end
end
