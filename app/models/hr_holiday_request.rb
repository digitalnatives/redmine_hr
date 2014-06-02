class HrHolidayRequest < ActiveRecord::Base
  unloadable
  set_inheritance_column 'holday_request'

  STATUSES = %w(planned requested rejected approved withdrawn).freeze

  belongs_to :hr_employee_profile

  validates :start_date, :end_date, :status, :type, presence: true
  validates :type,   inclusion: { in: %w(sick_leave holiday) }
  validates :status, inclusion: { in: STATUSES }
  validate  :date_validations

  after_initialize :init

  scope :by_year, ->(date) {
    boy = date.beginning_of_year
    eoy = date.end_of_year
    where("start_date >= ? and start_date <= ?", boy, eoy)
  }

  def init
    self.status ||= 'planned'
    self.type   ||= 'holiday'
  end

  def half_day?
    self.half_day
  end

  def date_validations
    return unless start_date.present? && end_date.present?

    if start_date > end_date
      errors.add(:end_date, "Should be bigger the start date")
    end

    if half_day? && start_date.beginning_of_day != end_date.beginning_of_day
      errors.add(:half_day, "Start Date and End Date must be the same, if holiday is half day.")
    end

    if !half_day? && start_date.year != end_date.year
      errors.add(:year, "Start Date and End Date must be in the same year")
    end
  end

  def as_json(options = {})
    super :root => false
  end
end