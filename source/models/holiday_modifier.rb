class HolidayModifier < Fron::Model
  field :year
  field :description
  field :value
  field :hr_employee_profile_id

  adapter Fron::Adapters::RailsAdapter, {
    endpoint: -> {
      `window.location.origin`+"/hr_employee_profiles/#{self.hr_employee_profile_id}"
    },
    resources: 'hr_holiday_modifiers',
    resource: 'hr_holiday_modifier'
  }
end
