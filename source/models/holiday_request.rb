require 'time'

class HolidayRequest < Fron::Model
  attr_reader :data

  field :start_date
  field :end_date
  field :request_type
  field :status
  field :half_day
  field :description
  field :hr_employee_profile_id

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: `window.location.origin`,
    resources: 'hr_holiday_requests',
    resource: 'hr_holiday_request'
  }

  def method_missing(method)
    @data[method]
  end
end
