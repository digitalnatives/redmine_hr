class HrEmployeeProfile < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  unloadable

  belongs_to :user
  belongs_to :supervisor, :class_name => "User"

  has_many :hr_holiday_modifiers
  has_many :hr_holiday_requests
  has_many :hr_employee_children

  validates :gender, inclusion: {in: %w{male female}}
  validates :birth_date, presence: true
  validates :employment_date, presence: true

  after_initialize :init

  def init
    self.gender          ||= 'male'
    self.birth_date      ||= Date.new(1980,01,01)
    self.employment_date ||= Date.new(1980,01,01)
  end

  def age
    ((Date.today.beginning_of_year - birth_date.beginning_of_year).to_i / 365)
  end

  def children
    hr_employee_children
  end

  def as_json(options = {})
    data = super :root => false
    data[:user] = user.as_json(:root => false)
    data[:supervisor] = supervisor.as_json(:root => false)
    data[:holiday_modifiers] = hr_holiday_modifiers.map(&:as_json)
    data[:employee_children] = hr_employee_children.map(&:as_json)
    data[:profile_info] = HrHolidayCalculator.profile_info self, Date.today
    data
  end
end
