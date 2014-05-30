class HrHolidayRequest < ActiveRecord::Base
  unloadable
  set_inheritance_column 'holday_request'

  STATUSES = %w(planned requested rejected approved withdrawn deleted).freeze

  EVENTS = {
    admin: [:approve , :reject, :approve_withdrawn, :reject_withdrawn, :update],
    user:  [:request, :cancel, :withdraw, :remove,  :update]
  }

  belongs_to :hr_employee_profile
  has_many   :audits, dependent: :delete_all

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

  SM = state_machine :status, :initial => :planned do
    event(:request)           { transition :planned                => :requested }
    event(:withdraw)          { transition :approved               => :withdrawn }
    event(:cancel)            { transition :requested              => :planned   }
    event(:approve)           { transition [:requested,:rejected]  => :approved  }
    event(:remove)            { transition [:requested,:planned]   => :deleted   }
    event(:approve_withdrawn) { transition :withdrawn              => :planned   }
    event(:reject_withdrawn)  { transition :withdrawn              => :approved  }

    event(:reject) do
      transition [:requested,:approved]  => :rejected, :if => lambda {|request| request.in_the_future?}
    end

    after_transition on: :remove do |request|
      request.destroy
    end

    after_transition except: :remove do |request,transition|
      user_id = User.current ? User.current.id : nil
      request.audits.create({from: transition.from, to: transition.to, user_id: user_id})
    end
  end

  def init
    self.status ||= 'planned'
    self.type   ||= 'holiday'
  end

  def user_allowed_to?(user,method)
    type = user.hr_admin? ? :admin : :user
    type = :admin if hr_employee_profile.supervisor == user
    type = :user  if hr_employee_profile.user == user
    puts method, EVENTS[type].include?(method.to_sym)
    EVENTS[type].include?(method.to_sym)
  end

  def half_day?
    self.half_day
  end

  def in_the_future?
    start_date.beginning_of_day >= Date.today && end_date.beginning_of_day >= Date.today
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
    available_statuses = status_paths(from: status).map{|path| path[0].event}.uniq
    data = super :root => false
    data[:available_statuses] = available_statuses.select{ |status| user_allowed_to?(User.current,status) }
    data[:user] = hr_employee_profile.user.name
    data[:audits] = audits.map(&:as_json)
    data
  end
end
