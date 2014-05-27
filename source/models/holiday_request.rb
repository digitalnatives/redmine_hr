class HolidayRequest < Fron::Model
  field :start_date
  field :end_date
  field :type
  field :status
  field :half_day

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: `window.location.origin`,
    resources: 'hr_holiday_requests',
    resource: 'hr_holiday_request'
  }
end
