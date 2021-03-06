class HrHolidayRequest < ActiveRecord::Base
  unloadable

  STATUSES = %w(planned requested rejected approved withdrawn deleted).freeze

  belongs_to :hr_employee_profile
  has_many   :hr_audits, dependent: :delete_all

  validates :start_date, :end_date, :status, :request_type, :hr_employee_profile_id, presence: true
  validates :request_type,   inclusion: { in: %w(sick_leave holiday) }
  validates :status, inclusion: { in: STATUSES }
  validate  :date_validations
  validate  :day_count_validation
  validate  :overlap_validation

  after_initialize :init

  scope :holidays, -> { where request_type: 'holiday' }
  scope :sick_leaves, -> { where request_type: 'sick_leave' }

  scope :by_user, ->(id) {
    where(hr_employee_profile_id: id)
  }

  scope :by_status, ->(status) {
    where(status: status)
  }

  scope :by_supervisor, ->(id) {
    joins(:hr_employee_profile).where("hr_employee_profiles.supervisor_id = ?", id)
  }

  scope :by_year, ->(date) {
    boy = date.beginning_of_year
    eoy = date.end_of_year
    where("start_date >= ? and start_date <= ?", boy, eoy)
  }

  scope :by_month, ->(date) {
    boy = date.beginning_of_month
    eoy = date.end_of_month
    where("start_date >= ? and start_date <= ?", boy, eoy)
  }

  SM = state_machine :status, :initial => :planned do
    event(:request)           { transition :planned                => :requested }
    event(:cancel)            { transition :requested              => :planned   }
    event(:approve)           { transition [:requested,:rejected]  => :approved  }
    event(:remove)            { transition [:requested,:planned]   => :deleted   }
    event(:approve_withdrawn) { transition :withdrawn              => :planned   }
    event(:reject_withdrawn)  { transition :withdrawn              => :approved  }

    event(:reject) do
      transition [:requested,:approved]  => :rejected, :if => lambda { |request| request.in_the_future? }
    end

    event(:withdraw) do
      transition :approved  => :withdrawn, :if => lambda { |request| request.in_the_future? }
    end

    after_transition do |request,transition|
      user_id = User.current ? User.current.id : nil
      request.hr_audits.create({from: transition.from, to: transition.to, user_id: user_id})
    end

    after_transition on: :remove   do |request| request.destroy end

    {
      request: 'requested',
      approve: 'approved',
      reject: 'rejected',
      withdraw: 'withdrawn',
      approve_withdrawn: 'approved_withdrawn',
      reject_withdrawn: 'rejected_withdrawn'
    }.each do |event,mail|
      after_transition on: event  do |request|
        HrMailer.send(mail,request).deliver
      end
    end
  end

  def init
    self.status       ||= 'planned'
    self.request_type ||= 'holiday'
  end

  def half_day?
    self.half_day
  end

  def in_the_future?
    start_date.beginning_of_day >= Date.today && end_date.beginning_of_day >= Date.today
  end

  def overlap_validation
    return unless hr_employee_profile
    return unless start_date.present? && end_date.present?
    overlaps = hr_employee_profile.hr_holiday_requests
    .select { |request| request != self   }
    .select { |request| overlaps? request }
    return if overlaps.count == 0
    errors.add :date, "Overlaps with an other holiday_request"
  end

  def overlaps?(other)
    start_date.to_date <= other.end_date.to_date && other.start_date.to_date <= end_date.to_date
  end

  def day_count_validation
    return if request_type == 'sick_leave'
    return unless start_date.present? && end_date.present?
    return unless hr_employee_profile
    info = HrHolidayCalculator.profile_info hr_employee_profile, start_date, self
    if info[:unused_planned] < days
      errors.add(:days, "You don't have enough days to request this holiday!")
    end
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

  def days
    return 0 unless defined? HrHolidayCalculator
    HrHolidayCalculator.calculate_duration self
  end

  def as_json(options = {})
    ability = HrAbility.new(User.current)
    available_statuses = status_paths(from: status).map{|path| path[0].event}.uniq
    data = super :root => false
    data[:available_statuses] = available_statuses.select{ |status| ability.can?(status,self) }
    data[:user] = hr_employee_profile.user.name
    if hr_employee_profile.supervisor
      data[:supervisor] = hr_employee_profile.supervisor.name
    end
    data[:days]       = days
    data[:audits]     = hr_audits.map(&:as_json)
    data[:can_update] = ability.can?(:update,self)
    data
  end
end
